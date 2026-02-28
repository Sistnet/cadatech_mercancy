require "test_helper"

class StoreTest < ActiveSupport::TestCase
  test "table name is tenants" do
    assert_equal "tenants", Store.table_name
  end

  test "active scope returns only active stores" do
    results = Store.active
    assert results.all?(&:active?)
    assert_includes results, stores(:active_store)
    assert_not_includes results, stores(:inactive_store)
  end

  test "inactive scope returns only inactive stores" do
    results = Store.inactive
    assert results.none?(&:active?)
    assert_includes results, stores(:inactive_store)
  end

  test "created_today scope returns stores created today" do
    results = Store.created_today
    assert_includes results, stores(:active_store)
    assert_not_includes results, stores(:old_store)
  end

  test "created_this_week scope returns stores created this week" do
    results = Store.created_this_week
    assert_includes results, stores(:active_store)
  end

  test "created_this_month scope returns stores created this month" do
    results = Store.created_this_month
    assert_includes results, stores(:active_store)
  end

  test "trial scope returns stores with trial subscription" do
    results = Store.trial
    assert_includes results, stores(:trial_store)
    assert_not_includes results, stores(:active_store)
  end

  test "subscribed scope returns stores with active subscription" do
    results = Store.subscribed
    assert_includes results, stores(:active_store)
    assert_not_includes results, stores(:trial_store)
  end

  test "has_one setting association" do
    store = stores(:active_store)
    assert_instance_of StoreSetting, store.setting
    assert_equal "Loja Ativa Ltda", store.setting.business_name
  end

  test "new_count returns count for period" do
    count = Store.new_count(period: "today")
    assert_kind_of Integer, count
  end

  test "new_count_previous returns count for previous period" do
    count = Store.new_count_previous(period: "today")
    assert_kind_of Integer, count
  end

  test "scope_for_period returns correct scope" do
    assert_equal Store.created_today.to_sql, Store.scope_for_period("today").to_sql
    assert_equal Store.created_this_week.to_sql, Store.scope_for_period("week").to_sql
    assert_equal Store.created_this_month.to_sql, Store.scope_for_period("month").to_sql
  end

  test "scope_for_period defaults to today" do
    assert_equal Store.created_today.to_sql, Store.scope_for_period("unknown").to_sql
  end
end
