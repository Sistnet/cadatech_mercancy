module SubscriptionPlansHelper
  PLAN_STATUS_STYLES = {
    "active" => "bg-green-100 text-green-800",
    "inactive" => "bg-gray-100 text-gray-800",
    "archived" => "bg-yellow-100 text-yellow-800"
  }.freeze

  PLAN_STATUS_SELECT_STYLES = {
    "active" => "bg-green-100 text-green-800 border-green-200",
    "inactive" => "bg-gray-100 text-gray-800 border-gray-200",
    "archived" => "bg-yellow-100 text-yellow-800 border-yellow-200"
  }.freeze

  def plan_status_badge(status)
    css = PLAN_STATUS_STYLES.fetch(status, "bg-gray-100 text-gray-800")
    label = t("subscription_plans.statuses.#{status}", default: status&.capitalize)
    tag.span label, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{css}"
  end

  def plan_status_select_class(status)
    PLAN_STATUS_SELECT_STYLES.fetch(status, "bg-gray-100 text-gray-800 border-gray-200")
  end
end
