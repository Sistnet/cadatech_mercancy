require "test_helper"

class TenantTest < ActiveSupport::TestCase
  test "table name is tenants" do
    assert_equal "tenants", Tenant.table_name
  end

  test "active scope returns only active tenants" do
    results = Tenant.active
    assert results.all?(&:active?)
    assert_includes results, tenants(:active_tenant)
    assert_not_includes results, tenants(:inactive_tenant)
  end

  test "inactive scope returns only inactive tenants" do
    results = Tenant.inactive
    assert results.none?(&:active?)
    assert_includes results, tenants(:inactive_tenant)
  end

  test "has_one store association" do
    tenant = tenants(:active_tenant)
    assert_instance_of Store, tenant.store
    assert_equal stores(:active_store), tenant.store
  end

  test "has_one setting association" do
    tenant = tenants(:active_tenant)
    assert_instance_of StoreSetting, tenant.setting
    assert_equal "Loja Ativa Ltda", tenant.setting.business_name
  end
end
