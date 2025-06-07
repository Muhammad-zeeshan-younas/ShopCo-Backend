class Variant < ApplicationRecord
    # Standard sizes (can be customized)
    SIZES = %w[XS S M L XL XXL].freeze
    COLORS = %w[Red Blue Green Black White].freeze # Example options
  
    belongs_to :product
  
    validates :size, presence: true, inclusion: { in: SIZES }
    validates :color, presence: true, inclusion: { in: COLORS }
    validates :sku_suffix, presence: true, uniqueness: true
    validates :price_adjustment, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  
    def final_price
      product.base_price + price_adjustment
    end
  end
  