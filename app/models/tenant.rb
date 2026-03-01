class Tenant < ApplicationRecord
  has_one :store, dependent: :destroy
  has_one :setting, class_name: "StoreSetting", foreign_key: :tenant_id, dependent: :destroy, inverse_of: :tenant

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
