# app/blueprints/variant_blueprint.rb
class VariantBlueprint < Blueprinter::Base
  identifier :id

  # Core variant attributes
  fields :size, 
         :color, 
         :sku_suffix,
         :price_adjustment,
         :stock_quantity,
         :created_at,
         :updated_at

  # Calculated fields
  field :final_price do |variant|
    variant.final_price.round(2)
  end

  field :in_stock do |variant|
    variant.stock_quantity.positive?
  end

  field :low_stock do |variant|
    variant.stock_quantity < 10 # Custom threshold
  end

end