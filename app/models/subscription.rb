class Subscription < ApplicationRecord
  belongs_to :store
  belongs_to :subscription_plan
  belongs_to :changed_by_admin, class_name: "Admin", foreign_key: :changed_by, optional: true, inverse_of: false

  validates :status, presence: true

  enum :status, {
    trial: "trial",
    active: "active",
    suspended: "suspended",
    cancelled: "cancelled",
    expired: "expired"
  }

  scope :current, -> { where(status: %w[trial active]) }
  scope :inactive, -> { where(status: %w[suspended cancelled expired]) }
  scope :expiring_soon, ->(days = 7) { current.where(ends_at: ..days.days.from_now) }
  scope :trial_expiring_soon, ->(days = 3) { trial.where(trial_ends_at: ..days.days.from_now) }
end
