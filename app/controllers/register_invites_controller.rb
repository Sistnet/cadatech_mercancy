class RegisterInvitesController < ApplicationController
  def index
    @status_filter = params[:status]
    @search = params[:search]

    scope = RegisterInvite.all
    scope = filter_by_status(scope) if @status_filter.present?
    scope = scope.where("email ILIKE :q", q: "%#{RegisterInvite.sanitize_sql_like(@search)}%") if @search.present?

    @total = scope.count
    @page = [ params.fetch(:page, 1).to_i, 1 ].max
    @offset = (@page - 1) * ApplicationHelper::PER_PAGE
    @invites = scope.order(created_at: :desc).offset(@offset).limit(ApplicationHelper::PER_PAGE)
    @total_pages = (@total.to_f / ApplicationHelper::PER_PAGE).ceil
  end

  def resend
    invite = RegisterInvite.find(params[:id])

    unless invite.expired? && !invite.used?
      redirect_to register_invites_path, alert: t("register_invites.flash.resend_not_allowed")
      return
    end

    new_invite = RegisterInvite.create!(
      email: invite.email,
      created_by: current_admin.name,
      notes: invite.notes
    )
    InviteMailer.invite_email(new_invite).deliver_later
    redirect_to register_invites_path, notice: t("register_invites.flash.resent")
  end

  def new
    @invite = RegisterInvite.new
  end

  def destroy
    invite = RegisterInvite.find(params[:id])
    invite.soft_delete!(current_admin.name)
    redirect_to register_invites_path, notice: t("register_invites.flash.deleted")
  end

  def create
    @invite = RegisterInvite.new(invite_params)
    @invite.created_by = current_admin.name

    if @invite.save
      InviteMailer.invite_email(@invite).deliver_later
      redirect_to register_invites_path, notice: t("register_invites.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.expect(register_invite: [ :email, :notes ])
  end

  def filter_by_status(scope)
    case @status_filter
    when "pending" then scope.valid
    when "used" then scope.used
    when "expired" then scope.expired
    else scope
    end
  end
end
