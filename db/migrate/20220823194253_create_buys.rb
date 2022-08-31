class CreateBuys < ActiveRecord::Migration[7.0]
  def change
    create_table :boughts do |t|
      t.boolean :buybook
      t.integer :book_id
      t.integer :user_id
      t.timestamps
    end
  end
end
