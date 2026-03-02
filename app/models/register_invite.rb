class RegisterInvite < ApplicationRecord
  validates :token, presence: true, uniqueness: true, length: { is: 64 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :expires_at, presence: true

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  default_scope { where(deleted_at: nil) }

  scope :valid, -> { where(used_at: nil).where("expires_at > ?", Time.current) }
  scope :used, -> { where.not(used_at: nil) }
  scope :expired, -> { where(used_at: nil).where("expires_at <= ?", Time.current) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  def used?
    used_at.present?
  end

  def expired?
    expires_at.past?
  end

  def deleted?
    deleted_at.present?
  end

  def valid_token?
    !used? && !expired? && !deleted?
  end

  def mark_as_used!
    update!(used_at: Time.current)
  end

  def soft_delete!(admin_name)
    update!(deleted_at: Time.current, deleted_by: admin_name)
  end

  def status_label
    if deleted? then "deleted"
    elsif used? then "used"
    elsif expired? then "expired"
    else "pending"
    end
  end

  private

  def generate_token
    self.token ||= SecureRandom.alphanumeric(64)
  end

  def set_expiration
    self.expires_at ||= 72.hours.from_now
  end
end
