class SubscriptionPlansController < ApplicationController
  PER_PAGE = 20

  before_action :set_plan, only: %i[edit update update_status]

  def index
    @status_filter = params[:status]
    @search = params[:search]

    @total_plans = SubscriptionPlan.count
    @active_plans = SubscriptionPlan.active.count
    @inactive_archived = SubscriptionPlan.where(status: %w[inactive archived]).count
    @featured_plans = SubscriptionPlan.featured.count

    @status_chart = status_chart_data
    @subscriptions_chart = subscriptions_per_plan_chart_data

    scope = SubscriptionPlan.all
    scope = scope.where(status: @status_filter) if @status_filter.present?
    scope = scope.search(@search) if @search.present?

    @total = scope.count
    @page = [ params.fetch(:page, 1).to_i, 1 ].max
    @offset = (@page - 1) * PER_PAGE
    @plans = scope.order(:sort_order, :name).offset(@offset).limit(PER_PAGE)
    @total_pages = (@total.to_f / PER_PAGE).ceil
  end

  def new
    @plan = SubscriptionPlan.new
  end

  def create
    @plan = SubscriptionPlan.new(plan_params)

    if @plan.save
      redirect_to subscription_plans_path, notice: t("subscription_plans.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to subscription_plans_path, notice: t("subscription_plans.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    if @plan.update(status: params[:status])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @plan,
            partial: "subscription_plans/plan_row",
            locals: { plan: @plan }
          )
        end
        format.html { redirect_to subscription_plans_path, notice: t("subscription_plans.flash.status_updated") }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def set_plan
    @plan = SubscriptionPlan.find(params[:id])
  end

  def plan_params
    params.expect(subscription_plan: [
      :name, :slug, :status, :description, :sort_order,
      :price_monthly, :price_yearly, :setup_fee, :transaction_fee, :commission_rate,
      :max_products, :max_services, :max_storage_mb, :max_monthly_orders,
      :trial_enabled, :trial_days,
      :api_access, :custom_domain, :advanced_analytics, :priority_support,
      :delivery_management, :white_label, :seo_tools, :social_media_integration, :featured_listing,
      :is_active, :is_featured
    ])
  end

  def status_chart_data
    counts = SubscriptionPlan.group(:status).count
    colors = { "active" => "#22c55e", "inactive" => "#9ca3af", "archived" => "#eab308" }

    {
      labels: counts.keys.map { |s| I18n.t("subscription_plans.statuses.#{s}") },
      datasets: [ {
        data: counts.values,
        backgroundColor: counts.keys.map { |s| colors[s] || "#6b7280" }
      } ]
    }
  end

  def subscriptions_per_plan_chart_data
    counts = Subscription.group(:subscription_plan_id).count
    plans = SubscriptionPlan.where(id: counts.keys).index_by(&:id)

    {
      labels: counts.keys.map { |id| plans[id]&.name || "—" },
      datasets: [ {
        label: I18n.t("subscription_plans.charts.subscriptions_label"),
        data: counts.values,
        backgroundColor: "#3b82f6"
      } ]
    }
  end
end
