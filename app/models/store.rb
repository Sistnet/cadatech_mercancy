class Store < ApplicationRecord
  belongs_to :tenant
  has_many :subscriptions, dependent: :destroy
  def current_subscription
    subscriptions.current.order(started_at: :desc).first
  end

  enum :status, { active: "active", inactive: "inactive", suspended: "suspended" }

  scope :created_today, -> { where(created_at: Time.current.all_day) }
  scope :created_this_week, -> { where(created_at: Time.current.all_week) }
  scope :created_this_month, -> { where(created_at: Time.current.all_month) }

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
