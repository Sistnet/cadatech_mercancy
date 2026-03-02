require "test_helper"

class InviteMailerTest < ActionMailer::TestCase
  test "invite_email sends to correct recipient" do
    invite = register_invites(:valid_invite)
    email = InviteMailer.invite_email(invite)

    assert_equal [ invite.email ], email.to
    assert_equal [ "noreply@mercancy.com.br" ], email.from
    assert_equal I18n.t("invite_mailer.invite_email.subject"), email.subject
  end

  test "invite_email body contains registration url" do
    invite = register_invites(:valid_invite)
    email = InviteMailer.invite_email(invite)
    html_body = email.html_part.body.decoded

    assert_match invite.token, html_body
    assert_match "/register?token=", html_body
  end

  test "invite_email delivers successfully" do
    invite = register_invites(:valid_invite)

    assert_emails 1 do
      InviteMailer.invite_email(invite).deliver_now
    end
  end
end
