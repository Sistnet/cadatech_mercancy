require "test_helper"

class DashboardHelperTest < ActionView::TestCase
  include DashboardHelper

  test "format_currency formats value in BRL" do
    assert_equal "R$ 1.234,56", format_currency(1234.56)
  end

  test "format_currency formats zero" do
    assert_equal "R$ 0,00", format_currency(0)
  end

  test "format_variation calculates positive percentage" do
    assert_equal 15.2, format_variation(124, 107.64)
  end

  test "format_variation calculates negative percentage" do
    assert_equal(-1.9, format_variation(256, 261))
  end

  test "format_variation returns nil for zero previous" do
    assert_nil format_variation(100, 0)
  end

  test "variation_color_class returns green for positive" do
    assert_equal "text-green-600", variation_color_class(12.5)
  end

  test "variation_color_class returns red for negative" do
    assert_equal "text-red-600", variation_color_class(-3.2)
  end

  test "variation_color_class returns gray for zero" do
    assert_equal "text-gray-500", variation_color_class(0)
  end

  test "variation_color_class returns gray for nil" do
    assert_equal "text-gray-500", variation_color_class(nil)
  end

  test "variation_icon returns up arrow for positive" do
    assert_equal "↑", variation_icon(12.5)
  end

  test "variation_icon returns down arrow for negative" do
    assert_equal "↓", variation_icon(-3.2)
  end

  test "status_badge returns span with translated label for entregue" do
    result = status_badge("entregue")
    assert_includes result, I18n.t("dashboard.statuses.entregue")
    assert_includes result, "bg-green-100"
    assert_includes result, "text-green-800"
  end

  test "status_badge returns span with translated label for cancelado" do
    result = status_badge("cancelado")
    assert_includes result, I18n.t("dashboard.statuses.cancelado")
    assert_includes result, "bg-red-100"
  end

  test "status_badge returns span with translated label for pendente" do
    result = status_badge("pendente")
    assert_includes result, I18n.t("dashboard.statuses.pendente")
    assert_includes result, "bg-yellow-100"
  end

  test "status_badge falls back to capitalized for unknown status" do
    result = status_badge("desconhecido")
    assert_includes result, "Desconhecido"
    assert_includes result, "bg-gray-100"
  end

  test "relative_time formats time ago" do
    result = relative_time(2.hours.ago)
    assert_match(/atrás\z/, result)
  end
end
