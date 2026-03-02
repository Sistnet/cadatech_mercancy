require "test_helper"

class SubscriptionPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(admins(:active_admin))
    @plan = subscription_plans(:pro_plan)
  end

  # === INDEX ===

  test "index renders plans list" do
    get subscription_plans_path
    assert_response :success
  end

  test "index requires authentication" do
    sign_out
    get subscription_plans_path
    assert_redirected_to new_session_path
  end

  test "index displays plans table" do
    get subscription_plans_path
    assert_select "table" do
      assert_select "th", text: I18n.t("subscription_plans.table.name")
      assert_select "th", text: I18n.t("subscription_plans.table.price")
      assert_select "th", text: I18n.t("subscription_plans.table.status")
    end
  end

  test "index displays kpi cards" do
    get subscription_plans_path
    assert_select "span", text: I18n.t("subscription_plans.kpis.total")
    assert_select "span", text: I18n.t("subscription_plans.kpis.active")
    assert_select "span", text: I18n.t("subscription_plans.kpis.inactive_archived")
    assert_select "span", text: I18n.t("subscription_plans.kpis.featured")
  end

  test "index filters by status" do
    get subscription_plans_path(status: "active")
    assert_response :success
  end

  test "index searches by name" do
    get subscription_plans_path(search: "Profissional")
    assert_response :success
    assert_select "td div", text: "Profissional"
  end

  test "index search with no results" do
    get subscription_plans_path(search: "nonexistent_xyz")
    assert_response :success
    assert_select "td", text: I18n.t("subscription_plans.table.empty")
  end

  test "index paginates results" do
    get subscription_plans_path(page: 1)
    assert_response :success
  end

  # === NEW ===

  test "new renders form" do
    get new_subscription_plan_path
    assert_response :success
    assert_select "form"
  end

  test "new requires authentication" do
    sign_out
    get new_subscription_plan_path
    assert_redirected_to new_session_path
  end

  # === CREATE ===

  test "create with valid params creates plan" do
    assert_difference "SubscriptionPlan.count", 1 do
      post subscription_plans_path, params: { subscription_plan: {
        name: "Plano Teste",
        slug: "plano-teste",
        status: "active",
        price_monthly: 79.90,
        commission_rate: 4.0
      } }
    end
    assert_redirected_to subscription_plans_path
    assert_equal I18n.t("subscription_plans.flash.created"), flash[:notice]

    plan = SubscriptionPlan.find_by(slug: "plano-teste")
    assert_not_nil plan
    assert_not_nil plan.external_id
  end

  test "create with invalid params renders form with errors" do
    assert_no_difference "SubscriptionPlan.count" do
      post subscription_plans_path, params: { subscription_plan: { name: "", slug: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "create with duplicate slug renders form with errors" do
    assert_no_difference "SubscriptionPlan.count" do
      post subscription_plans_path, params: { subscription_plan: {
        name: "Duplicated", slug: @plan.slug, price_monthly: 10, commission_rate: 5
      } }
    end
    assert_response :unprocessable_entity
  end

  test "create requires authentication" do
    sign_out
    post subscription_plans_path, params: { subscription_plan: { name: "Test", slug: "test" } }
    assert_redirected_to new_session_path
  end

  # === EDIT ===

  test "edit renders form with plan data" do
    get edit_subscription_plan_path(@plan)
    assert_response :success
    assert_select "form"
  end

  test "edit requires authentication" do
    sign_out
    get edit_subscription_plan_path(@plan)
    assert_redirected_to new_session_path
  end

  # === UPDATE ===

  test "update with valid params" do
    patch subscription_plan_path(@plan), params: { subscription_plan: { name: "Nome Atualizado" } }
    assert_redirected_to subscription_plans_path
    assert_equal I18n.t("subscription_plans.flash.updated"), flash[:notice]
    assert_equal "Nome Atualizado", @plan.reload.name
  end

  test "update with invalid params renders form with errors" do
    patch subscription_plan_path(@plan), params: { subscription_plan: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "update requires authentication" do
    sign_out
    patch subscription_plan_path(@plan), params: { subscription_plan: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  # === UPDATE STATUS ===

  test "update_status changes plan status" do
    patch update_status_subscription_plan_path(@plan), params: { status: "inactive" }, as: :turbo_stream
    assert_response :success
    assert_equal "inactive", @plan.reload.status
  end

  test "update_status with html format redirects" do
    patch update_status_subscription_plan_path(@plan, format: :html), params: { status: "archived" }
    assert_redirected_to subscription_plans_path
    assert_equal "archived", @plan.reload.status
  end

  test "update_status rejects invalid status" do
    patch update_status_subscription_plan_path(@plan), params: { status: "bogus" }
    assert_response :unprocessable_entity
    assert_equal "active", @plan.reload.status
  end

  test "update_status requires authentication" do
    sign_out
    patch update_status_subscription_plan_path(@plan), params: { status: "inactive" }
    assert_redirected_to new_session_path
  end
end
