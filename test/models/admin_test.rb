require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "authenticate_by with valid credentials" do
    admin = Admin.authenticate_by(email: admins(:active_admin).email, password: "password123")
    assert admin
    assert_equal admins(:active_admin).id, admin.id
  end

  test "authenticate_by with wrong password" do
    admin = Admin.authenticate_by(email: admins(:active_admin).email, password: "wrong")
    assert_nil admin
  end

  test "authenticate_by with nonexistent email" do
    admin = Admin.authenticate_by(email: "noone@example.com", password: "password123")
    assert_nil admin
  end

  test "authenticate_by with blank password" do
    admin = Admin.authenticate_by(email: admins(:active_admin).email, password: "")
    assert_nil admin
  end

  test "record_login updates last_login_at and resets attempts" do
    admin = admins(:active_admin)
    admin.update_columns(login_attempts: 3)
    admin.record_login!
    admin.reload
    assert_equal 0, admin.login_attempts
    assert_not_nil admin.last_login_at
  end

  test "increment_login_attempts locks after 5 attempts" do
    admin = admins(:active_admin)
    5.times do
      admin.reload
      admin.increment_login_attempts!
    end
    admin.reload
    assert admin.locked?
    assert_equal 5, admin.login_attempts
  end

  test "active scope excludes inactive admins" do
    assert_not_includes Admin.active, admins(:inactive_admin)
  end

  test "unlocked scope excludes locked admins" do
    assert_not_includes Admin.unlocked, admins(:locked_admin)
  end
end
