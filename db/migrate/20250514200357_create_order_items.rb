# db/migrate/YYYYMMDDHHMMSS_create_order_items.rb
class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :variant, foreign_key: { to_table: :variants }
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.timestamps
    end

    add_index :order_items, [:order_id, :product_id, :variant_id], unique: true, name: 'index_order_items_on_order_product_variant'
  end
end