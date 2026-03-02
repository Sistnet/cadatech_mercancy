class AddSoftDeleteToRegisterInvites < ActiveRecord::Migration[8.1]
  def change
    add_column :register_invites, :deleted_at, :datetime
    add_column :register_invites, :deleted_by, :string
  end
end
