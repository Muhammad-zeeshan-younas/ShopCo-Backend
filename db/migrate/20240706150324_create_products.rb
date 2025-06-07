class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :base_price, precision: 10, scale: 2, null: false
      t.string :category, null: false
      t.string :sku, null: false
      t.decimal :rating, precision: 3, scale: 2, default: 0.0
      
      t.decimal :discount_percentage, precision: 5, scale: 2
      t.boolean :featured, default: false
      t.timestamps
    end
  end
end
