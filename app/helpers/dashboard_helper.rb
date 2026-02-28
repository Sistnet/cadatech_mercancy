module DashboardHelper
  def format_currency(value)
    number_to_currency(value)
  end

  def format_variation(current, previous)
    return nil if previous.zero?
    ((current - previous).to_f / previous * 100).round(1)
  end

  def variation_color_class(variation)
    if variation.nil? || variation.zero?
      "text-gray-500"
    elsif variation.positive?
      "text-green-600"
    else
      "text-red-600"
    end
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
