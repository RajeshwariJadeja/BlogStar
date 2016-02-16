class ChangeDataTypeForDateOfBirth < ActiveRecord::Migration
  def up
  	change_column :users, :date_of_birth,  :date
  end

  def down
  end
end
