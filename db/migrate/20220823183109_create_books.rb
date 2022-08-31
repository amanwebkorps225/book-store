class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name
      t.string :author
      t.integer :price
      t.integer :user_id

      t.timestamps
    end
  end
end
