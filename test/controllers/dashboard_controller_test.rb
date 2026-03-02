require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(admins(:active_admin)) }

  test "index renders dashboard" do
    get root_path
    assert_response :success
  end

  test "index displays kpi cards" do
    get root_path
    assert_select "p", text: "124"
    assert_select "p", text: /R\$ 8\.450,00/
    assert_select "p", text: "38"
    assert_select "p", text: "256"
    assert_select "p", text: /R\$ 68,15/
  end

  test "index displays period toggle" do
    get root_path
    assert_select "a", text: I18n.t("dashboard.periods.today")
    assert_select "a", text: I18n.t("dashboard.periods.week")
    assert_select "a", text: I18n.t("dashboard.periods.month")
  end

  test "index accepts period parameter" do
    get root_path(period: "week")
    assert_response :success
  end

  test "index displays chart sections" do
    get root_path
    assert_select "h2", text: I18n.t("dashboard.charts.sales_title")
    assert_select "h2", text: I18n.t("dashboard.charts.status_title")
    assert_select "canvas[data-controller='chart']", 2
  end

  test "index displays recent orders table" do
    get root_path
    assert_select "h2", text: I18n.t("dashboard.recent_orders.title")
    assert_select "table" do
      assert_select "th", text: I18n.t("dashboard.recent_orders.order")
      assert_select "th", text: I18n.t("dashboard.recent_orders.customer")
      assert_select "th", text: I18n.t("dashboard.recent_orders.value")
      assert_select "th", text: I18n.t("dashboard.recent_orders.status")
      assert_select "th", text: I18n.t("dashboard.recent_orders.date")
      assert_select "tbody tr", 10
    end
  end

  test "index displays activity log" do
    get root_path
    assert_select "h2", text: I18n.t("dashboard.activity.title")
    assert_select "span.font-medium", text: "Admin", minimum: 1
  end

  test "index wraps content in turbo frame" do
    get root_path
    assert_select "turbo-frame[id='dashboard']"
  end

  test "period toggle highlights active period" do
    get root_path(period: "week")
    assert_select "a.bg-blue-600", text: I18n.t("dashboard.periods.week")
  end

  test "turbo frame request returns matching frame" do
    get root_path(period: "month"), headers: { "Turbo-Frame" => "dashboard" }
    assert_response :success
    assert_select "turbo-frame[id='dashboard']"
  end
end
