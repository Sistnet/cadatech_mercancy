class StoreSetting < ApplicationRecord
  self.table_name = "tenant_settings"

  belongs_to :store, foreign_key: :tenant_id, inverse_of: :setting
  belongs_to :subscription_plan, optional: true

  enum :subscription_status, {
    trial: "trial",
    active: "active",
    suspended: "suspended",
    cancelled: "cancelled",
    expired: "expired"
  }

  scope :not_deleted, -> { where(deleted_at: nil) }
end
