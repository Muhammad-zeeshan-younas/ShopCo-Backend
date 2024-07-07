class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, default: 0
      t.string :category, null: false
      t.string :sku, null: false
      t.string :image_url
      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
