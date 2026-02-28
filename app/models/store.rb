class Store < ApplicationRecord
  self.table_name = "tenants"

  has_one :setting, class_name: "StoreSetting", foreign_key: :tenant_id, dependent: :destroy, inverse_of: :store
  has_one :subscription_plan, through: :setting

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  scope :created_today, -> { where(created_at: Date.current.all_day) }
  scope :created_this_week, -> { where(created_at: Date.current.all_week) }
  scope :created_this_month, -> { where(created_at: Date.current.all_month) }

  scope :trial, -> { joins(:setting).where(tenant_settings: { subscription_status: "trial" }) }
  scope :subscribed, -> { joins(:setting).where(tenant_settings: { subscription_status: "active" }) }

  def self.new_count(period:)
    scope_for_period(period).count
  end

  def self.new_count_previous(period:)
    scope_for_previous_period(period).count
  end

  def self.scope_for_period(period)
    case period
    when "today" then created_today
    when "week" then created_this_week
    when "month" then created_this_month
    else created_today
    end
  end

  def self.scope_for_previous_period(period)
    case period
    when "today" then where(created_at: 1.day.ago.all_day)
    when "week" then where(created_at: 1.week.ago.all_week)
    when "month" then where(created_at: 1.month.ago.all_month)
    else where(created_at: 1.day.ago.all_day)
    end
  end
end
