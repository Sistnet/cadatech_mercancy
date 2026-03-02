class Tenant < ApplicationRecord
  has_one :store, dependent: :destroy
  has_one :setting, class_name: "StoreSetting", foreign_key: :tenant_id, dependent: :destroy, inverse_of: :tenant

  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true, uniqueness: true, length: { maximum: 100 }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
