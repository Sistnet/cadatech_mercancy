require "test_helper"

class SubscriptionPlanTest < ActiveSupport::TestCase
  test "table name is subscription_plans" do
    assert_equal "subscription_plans", SubscriptionPlan.table_name
  end

  test "status enum values" do
    assert_equal %w[active inactive archived], SubscriptionPlan.statuses.keys
  end

  test "available scope returns active and is_active plans ordered by sort_order" do
    results = SubscriptionPlan.available
    assert results.all? { |p| p.is_active? && p.active? }
    assert_equal results.map(&:sort_order), results.map(&:sort_order).sort
  end

  test "available scope excludes archived plans" do
    assert_not_includes SubscriptionPlan.available, subscription_plans(:archived_plan)
  end

  test "featured scope returns featured plans" do
    results = SubscriptionPlan.featured
    assert results.all?(&:is_featured?)
    assert_includes results, subscription_plans(:pro_plan)
  end

  test "with_trial scope returns plans with trial enabled" do
    results = SubscriptionPlan.with_trial
    assert results.all?(&:trial_enabled?)
    assert_includes results, subscription_plans(:basic_plan)
  end

  test "has_many store_settings" do
    plan = subscription_plans(:basic_plan)
    assert_respond_to plan, :store_settings
  end

  test "has_many subscriptions" do
    plan = subscription_plans(:pro_plan)
    assert_respond_to plan, :subscriptions
    assert_includes plan.subscriptions, subscriptions(:active_subscription)
  end
end
