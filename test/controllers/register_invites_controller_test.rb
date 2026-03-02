require "test_helper"

class RegisterInvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(admins(:active_admin))
  end

  # === INDEX ===

  test "index renders invites list" do
    get register_invites_path
    assert_response :success
  end

  test "index requires authentication" do
    sign_out
    get register_invites_path
    assert_redirected_to new_session_path
  end

  test "index displays invites table" do
    get register_invites_path
    assert_select "table" do
      assert_select "th", text: I18n.t("register_invites.table.email")
      assert_select "th", text: I18n.t("register_invites.table.status")
      assert_select "th", text: I18n.t("register_invites.table.created_by")
    end
  end

  test "index filters by status" do
    get register_invites_path(status: "pending")
    assert_response :success
  end

  test "index searches by email" do
    get register_invites_path(search: "convidado")
    assert_response :success
  end

  test "index search with no results" do
    get register_invites_path(search: "nonexistent_xyz")
    assert_response :success
    assert_select "td", text: I18n.t("register_invites.table.empty")
  end

  test "index paginates results" do
    get register_invites_path(page: 1)
    assert_response :success
  end

  # === NEW ===

  test "new renders form" do
    get new_register_invite_path
    assert_response :success
    assert_select "form"
  end

  test "new requires authentication" do
    sign_out
    get new_register_invite_path
    assert_redirected_to new_session_path
  end

  # === CREATE ===

  test "create with valid params creates invite" do
    assert_difference "RegisterInvite.count", 1 do
      post register_invites_path, params: { register_invite: {
        email: "novo@example.com",
        notes: "Teste de convite"
      } }
    end
    assert_redirected_to register_invites_path
    assert_equal I18n.t("register_invites.flash.created"), flash[:notice]

    invite = RegisterInvite.last
    assert_equal "novo@example.com", invite.email
    assert_equal "Test Admin", invite.created_by
    assert_equal 64, invite.token.length
    assert invite.expires_at > Time.current
  end

  test "create with missing email renders form with errors" do
    assert_no_difference "RegisterInvite.count" do
      post register_invites_path, params: { register_invite: { email: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "create requires authentication" do
    sign_out
    post register_invites_path, params: { register_invite: { email: "test@example.com" } }
    assert_redirected_to new_session_path
  end

  # === RESEND ===

  test "resend creates new invite for expired invite" do
    expired = register_invites(:expired_invite)
    assert_difference "RegisterInvite.count", 1 do
      post resend_register_invite_path(expired)
    end
    assert_redirected_to register_invites_path
    assert_equal I18n.t("register_invites.flash.resent"), flash[:notice]

    new_invite = RegisterInvite.last
    assert_equal expired.email, new_invite.email
    assert new_invite.valid_token?
  end

  test "resend is not allowed for valid invite" do
    valid = register_invites(:valid_invite)
    assert_no_difference "RegisterInvite.count" do
      post resend_register_invite_path(valid)
    end
    assert_redirected_to register_invites_path
    assert_equal I18n.t("register_invites.flash.resend_not_allowed"), flash[:alert]
  end

  test "resend is not allowed for used invite" do
    used = register_invites(:used_invite)
    assert_no_difference "RegisterInvite.count" do
      post resend_register_invite_path(used)
    end
    assert_redirected_to register_invites_path
    assert_equal I18n.t("register_invites.flash.resend_not_allowed"), flash[:alert]
  end

  test "resend requires authentication" do
    sign_out
    post resend_register_invite_path(register_invites(:expired_invite))
    assert_redirected_to new_session_path
  end

  # === DESTROY (soft delete) ===

  test "destroy soft deletes invite" do
    invite = register_invites(:valid_invite)
    delete register_invite_path(invite)
    assert_redirected_to register_invites_path
    assert_equal I18n.t("register_invites.flash.deleted"), flash[:notice]

    invite.reload
    assert invite.deleted?
    assert_equal "Test Admin", invite.deleted_by
  end

  test "destroy hides invite from default listing" do
    invite = register_invites(:valid_invite)
    delete register_invite_path(invite)

    get register_invites_path
    assert_response :success
    assert_select "td", text: invite.email, count: 0
  end

  test "destroy requires authentication" do
    sign_out
    delete register_invite_path(register_invites(:valid_invite))
    assert_redirected_to new_session_path
  end
end
