class SubscriptionPlan < ApplicationRecord
  has_many :store_settings, dependent: :restrict_with_error
  has_many :subscriptions, dependent: :restrict_with_error

  enum :status, { active: "active", inactive: "inactive", archived: "archived" }

  scope :available, -> { where(is_active: true).active.order(:sort_order) }
  scope :featured, -> { where(is_featured: true) }
  scope :with_trial, -> { where(trial_enabled: true) }
end
