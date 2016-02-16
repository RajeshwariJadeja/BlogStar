class RemoveColumn < ActiveRecord::Migration
  def up
  	 remove_column :users, :date_of_birth
  end

  def down
  	add_column :users, :date_of_birth, :datetime
  end
end
