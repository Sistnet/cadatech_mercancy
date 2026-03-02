class SubscriptionPlan < ApplicationRecord
  has_many :store_settings, dependent: :restrict_with_error
  has_many :subscriptions, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true, length: { maximum: 100 },
                   format: { with: /\A[a-z0-9\-]+\z/, message: :invalid_slug }
  validates :price_monthly, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :commission_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :transaction_fee, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :trial_days, numericality: { only_integer: true, greater_than: 0 }, if: :trial_enabled?

  before_validation :generate_external_id, on: :create

  enum :status, { active: "active", inactive: "inactive", archived: "archived" }

  scope :available, -> { where(is_active: true).active.order(:sort_order) }
  scope :featured, -> { where(is_featured: true) }
  scope :with_trial, -> { where(trial_enabled: true) }
  scope :search, ->(query) { where("name ILIKE :q OR slug ILIKE :q", q: "%#{sanitize_sql_like(query)}%") }

  private

  def generate_external_id
    self.external_id ||= SecureRandom.uuid
  end
end
