class AddRole1ToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role1, :integer,default: 0 
  end
end
