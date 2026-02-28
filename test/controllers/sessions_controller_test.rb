require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @admin = admins(:active_admin) }

  test "new renders login form" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    post session_path, params: { email: @admin.email, password: "password123" }
    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email: @admin.email, password: "wrong" }
    assert_redirected_to new_session_path
  end

  test "create with inactive admin credentials" do
    admin = admins(:inactive_admin)
    post session_path, params: { email: admin.email, password: "password123" }
    assert_redirected_to new_session_path
  end

  test "create with locked admin credentials" do
    admin = admins(:locked_admin)
    post session_path, params: { email: admin.email, password: "password123" }
    assert_redirected_to new_session_path
  end

  test "create increments login attempts on failure" do
    assert_changes -> { @admin.reload.login_attempts }, from: 0, to: 1 do
      post session_path, params: { email: @admin.email, password: "wrong" }
    end
  end

  test "destroy signs out" do
    sign_in_as(@admin)
    delete session_path
    assert_redirected_to new_session_path
  end

  test "unauthenticated access redirects to login" do
    get root_path
    assert_redirected_to new_session_path
  end
end
