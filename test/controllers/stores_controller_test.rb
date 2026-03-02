require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(admins(:active_admin))
    @store = stores(:active_store)
  end

  # === INDEX ===

  test "index renders stores list" do
    get stores_path
    assert_response :success
  end

  test "index requires authentication" do
    sign_out
    get stores_path
    assert_redirected_to new_session_path
  end

  test "index displays stores table" do
    get stores_path
    assert_select "table" do
      assert_select "th", text: I18n.t("stores.table.name")
      assert_select "th", text: I18n.t("stores.table.status")
      assert_select "th", text: I18n.t("stores.table.plan")
    end
  end

  test "index displays kpi cards" do
    get stores_path
    assert_select "span", text: I18n.t("stores.kpis.total")
    assert_select "span", text: I18n.t("stores.kpis.active")
    assert_select "span", text: I18n.t("stores.kpis.inactive_suspended")
    assert_select "span", text: I18n.t("stores.kpis.new_period")
  end

  test "index accepts period parameter" do
    get stores_path(period: "week")
    assert_response :success
  end

  test "index filters by status" do
    get stores_path(status: "active")
    assert_response :success
  end

  test "index searches by name" do
    get stores_path(search: "Loja Ativa")
    assert_response :success
    assert_select "td", text: "Loja Ativa"
  end

  test "index search with no results" do
    get stores_path(search: "nonexistent_xyz")
    assert_response :success
    assert_select "td", text: I18n.t("stores.table.empty")
  end

  test "index paginates results" do
    get stores_path(page: 1)
    assert_response :success
  end

  # === NEW ===

  test "new renders form" do
    get new_store_path
    assert_response :success
    assert_select "form"
  end

  test "new requires authentication" do
    sign_out
    get new_store_path
    assert_redirected_to new_session_path
  end

  # === CREATE ===

  test "create with valid params creates store and tenant" do
    assert_difference [ "Store.count", "Tenant.count" ], 1 do
      post stores_path, params: { store: {
        name: "Nova Loja Teste",
        slug: "nova-loja-teste",
        status: "active",
        email: "teste@example.com"
      } }
    end
    assert_redirected_to stores_path
    assert_equal I18n.t("stores.flash.created"), flash[:notice]

    store = Store.find_by(slug: "nova-loja-teste")
    assert_not_nil store
    assert_not_nil store.tenant
    assert_equal "Nova Loja Teste", store.tenant.name
    assert_not_nil store.external_id
  end

  test "create with invalid params renders form with errors" do
    assert_no_difference "Store.count" do
      post stores_path, params: { store: { name: "", slug: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "create with duplicate slug renders form with errors" do
    assert_no_difference "Store.count" do
      post stores_path, params: { store: { name: "Duplicated", slug: @store.slug } }
    end
    assert_response :unprocessable_entity
  end

  test "create requires authentication" do
    sign_out
    post stores_path, params: { store: { name: "Test", slug: "test" } }
    assert_redirected_to new_session_path
  end

  # === EDIT ===

  test "edit renders form with store data" do
    get edit_store_path(@store)
    assert_response :success
    assert_select "form"
  end

  test "edit requires authentication" do
    sign_out
    get edit_store_path(@store)
    assert_redirected_to new_session_path
  end

  # === UPDATE ===

  test "update with valid params" do
    patch store_path(@store), params: { store: { name: "Nome Atualizado" } }
    assert_redirected_to stores_path
    assert_equal I18n.t("stores.flash.updated"), flash[:notice]
    assert_equal "Nome Atualizado", @store.reload.name
  end

  test "update syncs tenant name" do
    patch store_path(@store), params: { store: { name: "Novo Nome" } }
    assert_equal "Novo Nome", @store.reload.tenant.name
  end

  test "update with invalid params renders form with errors" do
    patch store_path(@store), params: { store: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "update requires authentication" do
    sign_out
    patch store_path(@store), params: { store: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  # === UPDATE STATUS ===

  test "update_status changes store status" do
    patch update_status_store_path(@store), params: { status: "suspended" }, as: :turbo_stream
    assert_response :success
    assert_equal "suspended", @store.reload.status
  end

  test "update_status with html format redirects" do
    patch update_status_store_path(@store, format: :html), params: { status: "inactive" }
    assert_redirected_to stores_path
    assert_equal "inactive", @store.reload.status
  end

  test "update_status requires authentication" do
    sign_out
    patch update_status_store_path(@store), params: { status: "inactive" }
    assert_redirected_to new_session_path
  end

  # === UPDATE PLAN ===

  test "update_plan changes subscription plan" do
    subscription = subscriptions(:active_subscription)
    new_plan = subscription_plans(:basic_plan)
    patch update_plan_store_path(@store), params: { subscription_plan_id: new_plan.id }, as: :turbo_stream
    assert_response :success
    assert_equal new_plan.id, subscription.reload.subscription_plan_id
  end

  test "update_plan with html format redirects" do
    new_plan = subscription_plans(:basic_plan)
    patch update_plan_store_path(@store, format: :html), params: { subscription_plan_id: new_plan.id }
    assert_redirected_to stores_path
  end

  test "update_plan fails for store without current subscription" do
    store = stores(:inactive_store)
    new_plan = subscription_plans(:basic_plan)
    patch update_plan_store_path(store), params: { subscription_plan_id: new_plan.id }
    assert_response :unprocessable_entity
  end

  test "update_plan requires authentication" do
    sign_out
    patch update_plan_store_path(@store), params: { subscription_plan_id: 1 }
    assert_redirected_to new_session_path
  end
end
