require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  test "belongs to store" do
    subscription = subscriptions(:active_subscription)
    assert_instance_of Store, subscription.store
    assert_equal stores(:active_store), subscription.store
  end

  test "belongs to subscription_plan" do
    subscription = subscriptions(:active_subscription)
    assert_instance_of SubscriptionPlan, subscription.subscription_plan
    assert_equal subscription_plans(:pro_plan), subscription.subscription_plan
  end

  test "status enum values" do
    assert_equal %w[trial active suspended cancelled expired], Subscription.statuses.keys
  end

  test "current scope returns trial and active subscriptions" do
    results = Subscription.current
    assert results.all? { |s| s.trial? || s.active? }
    assert_includes results, subscriptions(:active_subscription)
    assert_includes results, subscriptions(:trial_subscription)
    assert_not_includes results, subscriptions(:cancelled_subscription)
  end

  test "inactive scope returns suspended, cancelled and expired subscriptions" do
    results = Subscription.inactive
    assert results.all? { |s| s.suspended? || s.cancelled? || s.expired? }
    assert_includes results, subscriptions(:cancelled_subscription)
    assert_not_includes results, subscriptions(:active_subscription)
  end

  test "expiring_soon scope returns current subscriptions ending within days" do
    results = Subscription.expiring_soon(7)
    assert_includes results, subscriptions(:expiring_subscription)
    assert_not_includes results, subscriptions(:active_subscription)
    assert_not_includes results, subscriptions(:cancelled_subscription)
  end

  test "trial_expiring_soon scope returns trials ending within days" do
    results = Subscription.trial_expiring_soon(3)
    assert_includes results, subscriptions(:trial_subscription)
  end
end
