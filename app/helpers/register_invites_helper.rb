module RegisterInvitesHelper
  INVITE_STATUS_STYLES = {
    "pending" => "bg-yellow-100 text-yellow-800",
    "used" => "bg-green-100 text-green-800",
    "expired" => "bg-gray-100 text-gray-800",
    "deleted" => "bg-red-100 text-red-800"
  }.freeze

  def invite_status_badge(invite)
    status = invite.status_label
    css = INVITE_STATUS_STYLES.fetch(status, "bg-gray-100 text-gray-800")
    label = t("register_invites.statuses.#{status}", default: status&.capitalize)
    tag.span label, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{css}"
  end

  def invite_url(invite)
    base_url = ENV.fetch("APP_URL", "https://partner-hml.mercancy.com.br")
    "#{base_url}/register?token=#{invite.token}"
  end
end
