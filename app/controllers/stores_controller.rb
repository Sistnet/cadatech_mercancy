class StoresController < ApplicationController
  before_action :set_store, only: %i[edit update update_status update_plan]

  def index
    @period = params[:period] || "today"
    @status_filter = params[:status]
    @search = params[:search]

    @total_stores = Store.count
    @active_stores = Store.active.count
    @inactive_suspended = Store.where(status: %w[inactive suspended]).count
    @new_stores = Store.new_count(period: @period)
    @new_stores_previous = Store.new_count_previous(period: @period)

    @status_chart = status_chart_data
    @growth_chart = growth_chart_data
    @subscription_chart = subscription_chart_data

    scope = Store.includes(:tenant, subscriptions: :subscription_plan)
    scope = scope.where(status: @status_filter) if @status_filter.present?
    scope = scope.search(@search) if @search.present?

    @total = scope.count
    @page = [ params.fetch(:page, 1).to_i, 1 ].max
    @offset = (@page - 1) * ApplicationHelper::PER_PAGE
    @stores = scope.order(created_at: :desc).offset(@offset).limit(ApplicationHelper::PER_PAGE)
    @total_pages = (@total.to_f / ApplicationHelper::PER_PAGE).ceil
    @plans = available_plans
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)

    ActiveRecord::Base.transaction do
      tenant = Tenant.create!(name: @store.name, slug: @store.slug, active: true)
      @store.tenant = tenant
      @store.save!
    end

    redirect_to stores_path, notice: t("stores.flash.created")
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update_status
    if @store.update(status: params[:status])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @store,
            partial: "stores/store_row",
            locals: { store: @store, plans: available_plans }
          )
        end
        format.html { redirect_to stores_path, notice: t("stores.flash.status_updated") }
      end
    else
      head :unprocessable_entity
    end
  end

  def update_plan
    subscription = @store.current_subscription

    unless subscription
      head :unprocessable_entity
      return
    end

    if subscription.update(subscription_plan_id: params[:subscription_plan_id])
      @store.reload
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @store,
            partial: "stores/store_row",
            locals: { store: @store, plans: available_plans }
          )
        end
        format.html { redirect_to stores_path, notice: t("stores.flash.plan_updated") }
      end
    else
      head :unprocessable_entity
    end
  end

  def update
    if @store.update(store_params)
      @store.tenant.update(name: @store.name, slug: @store.slug)
      redirect_to stores_path, notice: t("stores.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def available_plans
    SubscriptionPlan.available
  end

  def store_params
    params.expect(store: [
      :name, :slug, :status, :person_type,
      :email, :phone, :whatsapp,
      :cpf, :cnpj, :razao_social, :nome_fantasia,
      :commission_rate
    ])
  end

  def status_chart_data
    counts = Store.group(:status).count
    {
      labels: counts.keys.map { |s| I18n.t("stores.statuses.#{s}") },
      datasets: [ {
        data: counts.values,
        backgroundColor: counts.keys.map { |s|
          { "active" => "#22c55e", "inactive" => "#9ca3af", "suspended" => "#ef4444" }[s] || "#6b7280"
        }
      } ]
    }
  end

  def growth_chart_data
    range = 6.days.ago.beginning_of_day..Time.current.end_of_day
    counts_by_day = Store.where(created_at: range).group("DATE(created_at)").count
    labels = (6.days.ago.to_date..Date.current).map { |d| d.strftime("%d/%m") }
    data = (6.days.ago.to_date..Date.current).map { |d| counts_by_day[d] || 0 }

    {
      labels: labels,
      datasets: [ {
        label: I18n.t("stores.charts.growth_label"),
        data: data,
        backgroundColor: "#3b82f6"
      } ]
    }
  end

  def subscription_chart_data
    counts = Subscription.group(:status).count
    colors = {
      "trial" => "#8b5cf6", "active" => "#22c55e", "suspended" => "#f59e0b",
      "cancelled" => "#ef4444", "expired" => "#6b7280"
    }

    {
      labels: counts.keys.map { |s| I18n.t("stores.charts.subscription_statuses.#{s}") },
      datasets: [ {
        data: counts.values,
        backgroundColor: counts.keys.map { |s| colors[s] || "#6b7280" }
      } ]
    }
  end
end
