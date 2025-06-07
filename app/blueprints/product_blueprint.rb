class ProductBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :base_price, :category, :sku, 
         :discount_percentage, :featured, :created_at, :rating

  # Calculated fields
  field :discounted_price do |product|
    product.discounted_price
  end

  field :in_stock do |product|
    product.in_stock?
  end

  field :total_stock do |product|
    product.total_stock
  end
  
  field :is_new do |product|
    # You can either use the stored is_new flag or calculate dynamically
    if product.respond_to?(:is_new)
      product.is_new
    else
      # Example: consider products created in last 7 days as new
      product.created_at > 7.days.ago
    end
  end

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

  association :variants, blueprint: VariantBlueprint
  association :reviews, blueprint: ReviewBlueprint
end