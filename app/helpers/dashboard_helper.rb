module DashboardHelper
  KPI_CARD_THEMES = {
    "blue" => { bg: "bg-blue-200", border: "border-blue-300", icon: "text-blue-700", label: "text-blue-900", value: "text-blue-950", variation: "text-blue-800" },
    "green" => { bg: "bg-green-200", border: "border-green-300", icon: "text-green-700", label: "text-green-900", value: "text-green-950", variation: "text-green-800" },
    "purple" => { bg: "bg-purple-200", border: "border-purple-300", icon: "text-purple-700", label: "text-purple-900", value: "text-purple-950", variation: "text-purple-800" },
    "amber" => { bg: "bg-amber-200", border: "border-amber-300", icon: "text-amber-700", label: "text-amber-900", value: "text-amber-950", variation: "text-amber-800" },
    "indigo" => { bg: "bg-indigo-200", border: "border-indigo-300", icon: "text-indigo-700", label: "text-indigo-900", value: "text-indigo-950", variation: "text-indigo-800" }
  }.freeze

  def format_currency(value)
    number_to_currency(value)
  end

  def format_variation(current, previous)
    return nil if previous.zero?
    ((current - previous).to_f / previous * 100).round(1)
  end

  def variation_icon(variation)
    if variation.nil? || variation.zero?
      "→"
    elsif variation.positive?
      "↑"
    else
      "↓"
    end
  end

  STATUS_STYLES = {
    "confirmado" => "bg-blue-100 text-blue-800",
    "pendente" => "bg-yellow-100 text-yellow-800",
    "processando" => "bg-indigo-100 text-indigo-800",
    "enviado" => "bg-purple-100 text-purple-800",
    "entregue" => "bg-green-100 text-green-800",
    "cancelado" => "bg-red-100 text-red-800"
  }.freeze

  def status_badge(status)
    css = STATUS_STYLES.fetch(status, "bg-gray-100 text-gray-800")
    label = t("dashboard.statuses.#{status}", default: status.capitalize)
    tag.span label, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{css}"
  end

  def relative_time(time)
    t("datetime.distance_in_words.x_ago", time: time_ago_in_words(time))
  end
end
