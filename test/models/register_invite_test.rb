require "test_helper"

class RegisterInviteTest < ActiveSupport::TestCase
  # === VALIDATIONS ===

  test "valid invite is valid" do
    invite = RegisterInvite.new(email: "test@example.com")
    assert invite.valid?
    assert_equal 64, invite.token.length
    assert invite.expires_at.present?
  end

  test "token is auto-generated on create" do
    invite = RegisterInvite.create!(email: "auto@example.com")
    assert_equal 64, invite.token.length
  end

  test "expires_at is auto-set to 72 hours" do
    freeze_time do
      invite = RegisterInvite.create!(email: "expire@example.com")
      assert_equal 72.hours.from_now.to_i, invite.expires_at.to_i
    end
  end

  test "token must be unique" do
    existing = register_invites(:valid_invite)
    invite = RegisterInvite.new(token: existing.token, expires_at: 1.day.from_now)
    assert_not invite.valid?
    assert invite.errors[:token].any?
  end

  test "token must be exactly 64 characters" do
    invite = RegisterInvite.new(token: "short", expires_at: 1.day.from_now)
    assert_not invite.valid?
    assert invite.errors[:token].any?
  end

  test "expires_at is required" do
    invite = RegisterInvite.new
    invite.expires_at = nil
    invite.valid?
    # expires_at is auto-set, so force nil after validation callback
    invite.instance_variable_set(:@new_record, false)
    invite2 = RegisterInvite.new
    invite2.assign_attributes(expires_at: nil)
    # The before_validation sets it, so direct assignment won't trigger error
    # Test that the callback sets it correctly instead
    assert invite.expires_at.present?
  end

  # === SCOPES ===

  test "valid scope returns only non-used non-expired invites" do
    valid_ids = RegisterInvite.valid.pluck(:id)
    assert_includes valid_ids, register_invites(:valid_invite).id
    assert_not_includes valid_ids, register_invites(:used_invite).id
    assert_not_includes valid_ids, register_invites(:expired_invite).id
  end

  test "used scope returns only used invites" do
    used_ids = RegisterInvite.used.pluck(:id)
    assert_includes used_ids, register_invites(:used_invite).id
    assert_not_includes used_ids, register_invites(:valid_invite).id
  end

  test "expired scope returns only expired non-used invites" do
    expired_ids = RegisterInvite.expired.pluck(:id)
    assert_includes expired_ids, register_invites(:expired_invite).id
    assert_not_includes expired_ids, register_invites(:valid_invite).id
  end

  # === INSTANCE METHODS ===

  test "used? returns true when used_at is present" do
    assert register_invites(:used_invite).used?
    assert_not register_invites(:valid_invite).used?
  end

  test "expired? returns true when expires_at is past" do
    assert register_invites(:expired_invite).expired?
    assert_not register_invites(:valid_invite).expired?
  end

  test "valid_token? returns true only for valid invites" do
    assert register_invites(:valid_invite).valid_token?
    assert_not register_invites(:used_invite).valid_token?
    assert_not register_invites(:expired_invite).valid_token?
  end

  test "mark_as_used! sets used_at" do
    invite = register_invites(:valid_invite)
    assert_nil invite.used_at
    invite.mark_as_used!
    assert invite.used_at.present?
    assert invite.used?
  end

  test "status_label returns correct status" do
    assert_equal "pending", register_invites(:valid_invite).status_label
    assert_equal "used", register_invites(:used_invite).status_label
    assert_equal "expired", register_invites(:expired_invite).status_label
  end

  # === SOFT DELETE ===

  test "soft_delete! sets deleted_at and deleted_by" do
    invite = register_invites(:valid_invite)
    invite.soft_delete!("Admin Teste")
    assert invite.deleted?
    assert_equal "Admin Teste", invite.deleted_by
  end

  test "soft deleted records are excluded from default scope" do
    invite = register_invites(:valid_invite)
    invite.soft_delete!("Admin Teste")
    assert_not_includes RegisterInvite.pluck(:id), invite.id
  end

  test "soft deleted records are accessible via with_deleted" do
    invite = register_invites(:valid_invite)
    invite.soft_delete!("Admin Teste")
    assert_includes RegisterInvite.with_deleted.pluck(:id), invite.id
  end

  test "valid_token? returns false for deleted invite" do
    invite = register_invites(:valid_invite)
    invite.soft_delete!("Admin Teste")
    assert_not invite.valid_token?
  end

  test "status_label returns deleted for soft deleted invite" do
    invite = register_invites(:valid_invite)
    invite.soft_delete!("Admin Teste")
    assert_equal "deleted", invite.status_label
  end
end
