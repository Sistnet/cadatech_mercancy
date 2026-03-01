require "test_helper"

class StoreTest < ActiveSupport::TestCase
  test "belongs to tenant" do
    store = stores(:active_store)
    assert_instance_of Tenant, store.tenant
    assert_equal tenants(:active_tenant), store.tenant
  end

  test "has_many subscriptions" do
    store = stores(:active_store)
    assert_respond_to store, :subscriptions
    assert_includes store.subscriptions, subscriptions(:active_subscription)
  end

  test "status enum values" do
    assert_equal %w[active inactive suspended], Store.statuses.keys
  end

  test "active scope returns only active stores" do
    results = Store.active
    assert results.all?(&:active?)
    assert_includes results, stores(:active_store)
    assert_not_includes results, stores(:inactive_store)
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

  test "current_subscription returns the latest active subscription" do
    store = stores(:active_store)
    assert_equal subscriptions(:active_subscription), store.current_subscription
  end

  test "current_subscription returns nil when no active subscription" do
    store = stores(:inactive_store)
    assert_nil store.current_subscription
  end
end
