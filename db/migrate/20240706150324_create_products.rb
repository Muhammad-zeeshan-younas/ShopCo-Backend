class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      # Basic product info
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :category, null: false
      t.string :sku, null: false
      t.decimal :rating, precision: 3, scale: 2, default: 0.0
      
      # Inventory management
      t.integer :stock_quantity, default: 0
      t.boolean :in_stock, default: true
      t.integer :low_stock_threshold, default: 5
      
      # Product status flags
      t.boolean :is_new, default: false
      t.boolean :is_top_seller, default: false
      t.boolean :is_discounted, default: false
      t.decimal :original_price, precision: 10, scale: 2
      t.decimal :discount_percentage, precision: 5, scale: 2
      
      # Shipping info
      t.decimal :weight, precision: 8, scale: 2
      t.string :weight_unit, default: 'g'
      
      # SEO and display
      t.string :slug, null: false
      t.string :meta_title
      t.text :meta_description
      
      # Organization
      t.integer :position
      
      t.timestamps
    end
    
    add_index :products, :sku, unique: true
    add_index :products, :slug, unique: true
    add_index :products, :category
    add_index :products, :is_new
    add_index :products, :is_top_seller
    add_index :products, :is_discounted
    
    # Create variant tables
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.string :sku_suffix
      t.decimal :price_adjustment, precision: 10, scale: 2, default: 0.0
      t.integer :stock_quantity, default: 0
      t.timestamps
    end
    
    create_table :variant_options do |t|
      t.references :variant, null: false, foreign_key: { to_table: :product_variants }
      t.string :option_type, null: false  # 'color', 'size', etc
      t.string :value, null: false       # 'red', 'XL', etc
      t.timestamps
    end
    
    add_index :variant_options, [:variant_id, :option_type], unique: true
  end
end