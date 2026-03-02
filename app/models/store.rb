class Store < ApplicationRecord
  belongs_to :tenant
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true, length: { maximum: 100 },
                   uniqueness: true,
                   format: { with: /\A[a-z0-9\-]+\z/, message: :invalid_slug }
  validates :email, length: { maximum: 255 }, allow_blank: true
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :person_type, inclusion: { in: %w[pf pj] }, allow_blank: true
  validates :commission_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  before_validation :generate_external_id, on: :create

  enum :status, { active: "active", inactive: "inactive", suspended: "suspended" }

  scope :search, ->(query) { where("name ILIKE :q OR slug ILIKE :q", q: "%#{sanitize_sql_like(query)}%") }
  scope :created_today, -> { where(created_at: Time.current.all_day) }
  scope :created_this_week, -> { where(created_at: Time.current.all_week) }
  scope :created_this_month, -> { where(created_at: Time.current.all_month) }

  def current_subscription
    subscriptions.current.order(started_at: :desc).first
  end

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

  private

  def generate_external_id
    self.external_id ||= SecureRandom.uuid
  end
end
