class InviteMailer < ApplicationMailer
  def invite_email(invite)
    @invite = invite
    @registration_url = "#{ENV.fetch('APP_URL', 'https://partner-hml.mercancy.com.br')}/register?token=#{invite.token}"
    mail(to: invite.email, subject: t("invite_mailer.invite_email.subject"))
  end
end
