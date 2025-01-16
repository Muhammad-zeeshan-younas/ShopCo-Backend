# app/blueprints/product_blueprint.rb

class ProductBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :price, :stock_quantity, :category, :sku, :created_at, :updated_at, :rating

  field :images do |product, options|
    if product.images.attached?
      product.images.map do |image|
        Rails.application.routes.url_helpers.rails_blob_url(image, host: Rails.application.routes.default_url_options[:host], port: Rails.application.routes.default_url_options[:port])
      end
    else
      []
    end
  end

  association :reviews, blueprint: ReviewBlueprint
end
