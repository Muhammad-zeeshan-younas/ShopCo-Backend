class CreateVariant < ActiveRecord::Migration[7.1]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size, null: false
      t.string :color, null: false
      t.string :sku_suffix, null: false
      t.decimal :price_adjustment, default: 0.0
      t.integer :stock_quantity, default: 0
      t.timestamps
    end
  end
end
