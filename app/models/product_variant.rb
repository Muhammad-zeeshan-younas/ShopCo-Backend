class ProductVariant < ApplicationRecord
    belongs_to :product
    has_many :options, class_name: 'VariantOption', foreign_key: 'variant_id', dependent: :destroy
    accepts_nested_attributes_for :options, allow_destroy: true
    
    def full_sku
      "#{product.sku}-#{sku_suffix}"
    end
    
    def display_name
      options.map(&:value).join(' / ')
    end
  end
  