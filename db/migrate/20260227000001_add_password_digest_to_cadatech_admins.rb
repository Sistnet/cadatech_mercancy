class AddPasswordDigestToCadatechAdmins < ActiveRecord::Migration[8.1]
  def change
    add_column :cadatech_admins, :password_digest, :string
  end
end
