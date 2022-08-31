class AddQuantityToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :quantity, :integer
  end
end
