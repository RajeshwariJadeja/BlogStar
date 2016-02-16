class RemoveFlastNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :flast_name
      end

  def down
    add_column :users, :flast_name, :string
  end
end
