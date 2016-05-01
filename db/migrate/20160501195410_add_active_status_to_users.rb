class AddActiveStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_status, :boolean, default: false
  end
end
