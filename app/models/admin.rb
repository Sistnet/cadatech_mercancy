class Admin < ApplicationRecord
  self.table_name = "cadatech_admins"
  self.ignored_columns += [ "password" ]

  has_secure_password
  has_many :sessions, class_name: "AdminSession", dependent: :destroy

  enum :status, { active: "active", inactive: "inactive", suspended: "suspended" }
  enum :role, { super_admin: "super_admin", admin: "admin", moderator: "moderator", support: "support" }

  normalizes :email, with: ->(e) { e.strip.downcase }

  scope :unlocked, -> { where(locked_until: ..Time.current).or(where(locked_until: nil)) }

  def locked?
    locked_until.present? && locked_until > Time.current
  end

  def record_login!
    update_columns(last_login_at: Time.current, login_attempts: 0)
  end

  def increment_login_attempts!
    new_attempts = login_attempts + 1
    attrs = { login_attempts: new_attempts }
    attrs[:locked_until] = 30.minutes.from_now if new_attempts >= 5
    update_columns(attrs)
  end
end
