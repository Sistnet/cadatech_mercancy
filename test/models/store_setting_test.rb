require "test_helper"

class StoreSettingTest < ActiveSupport::TestCase
  test "table name is tenant_settings" do
    assert_equal "tenant_settings", StoreSetting.table_name
  end

  test "belongs to store" do
    setting = store_settings(:active_setting)
    assert_instance_of Store, setting.store
    assert_equal stores(:active_store), setting.store
  end

  test "subscription_status enum values" do
    assert_equal %w[trial active suspended cancelled expired], StoreSetting.subscription_statuses.keys
  end

  test "trial? returns true for trial setting" do
    assert store_settings(:trial_setting).trial?
  end

  test "active? returns true for active setting" do
    assert store_settings(:active_setting).active?
  end

  test "not_deleted scope excludes soft-deleted records" do
    results = StoreSetting.not_deleted
    assert results.all? { |s| s.deleted_at.nil? }
  end
end
