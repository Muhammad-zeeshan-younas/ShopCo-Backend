class ProductBlueprint < Blueprinter::Base
    identifier :sku  # Changed from :id to :sku since we're using SKU as the primary identifier
  
    fields :name, :description, :price, :stock_quantity, :category, 
           :rating, :weight, :weight_unit, :is_new, :is_top_seller, 
           :is_discounted, :original_price, :discount_percentage,
           :meta_title, :meta_description, :position, :low_stock_threshold,
           :in_stock, :created_at, :updated_at
  
    # Image handling
    field :images do |product, options|
      if product.images.attached?
        product.images.map do |image|
          Rails.application.routes.url_helpers.rails_blob_url(
            image, 
            host: options[:host] || Rails.application.routes.default_url_options[:host],
            port: options[:port] || Rails.application.routes.default_url_options[:port]
          )
        end
      else
        []
      end
    end
  
    # Calculated fields
    field :final_price do |product, options|
      if product.is_discounted && product.original_price.present?
        product.price  # price already reflects discount
      else
        product.price
      end
    end
  
    field :discount_amount do |product, options|
      if product.is_discounted && product.original_price.present?
        product.original_price - product.price
      else
        0
      end
    end
  
    # Associations
    association :variants, blueprint: VariantBlueprint
    association :reviews, blueprint: ReviewBlueprint
  
    # Different views for different contexts
    view :extended do
      fields :slug, :in_stock
      excludes :meta_title, :meta_description  # Don't expose SEO fields in basic views
    end
  
    view :detailed do
      include_view :extended
      fields :meta_title, :meta_description, :low_stock_threshold
    end
  
    view :admin do
      include_view :detailed
      fields :created_at, :updated_at, :position
    end
  end
  
  class VariantBlueprint < Blueprinter::Base
    identifier :id
  
    fields :name, :sku_suffix, :price_adjustment, :stock_quantity, :created_at, :updated_at
  
    field :full_sku do |variant, options|
      "#{variant.product.sku}-#{variant.sku_suffix}"
    end
  
    association :options, blueprint: VariantOptionBlueprint
  end
  
