module StoresHelper
  STORE_STATUS_STYLES = {
    "active" => "bg-green-100 text-green-800",
    "inactive" => "bg-gray-100 text-gray-800",
    "suspended" => "bg-red-100 text-red-800"
  }.freeze

  STORE_STATUS_SELECT_STYLES = {
    "active" => "bg-green-100 text-green-800 border-green-200",
    "inactive" => "bg-gray-100 text-gray-800 border-gray-200",
    "suspended" => "bg-red-100 text-red-800 border-red-200"
  }.freeze

  def store_status_badge(status)
    css = STORE_STATUS_STYLES.fetch(status, "bg-gray-100 text-gray-800")
    label = t("stores.statuses.#{status}", default: status&.capitalize)
    tag.span label, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{css}"
  end

  def store_status_select_class(status)
    STORE_STATUS_SELECT_STYLES.fetch(status, "bg-gray-100 text-gray-800 border-gray-200")
  end

  def pagination_info(offset, limit, total)
    first = [ offset + 1, total ].min
    last = [ offset + limit, total ].min
    t("stores.pagination.showing", first: first, last: last, total: total)
  end
end
