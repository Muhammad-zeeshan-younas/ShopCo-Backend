# app/models/order_item.rb
class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product
    belongs_to :variant, optional: true
  
    validates :quantity, numericality: { greater_than: 0 }
    validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  
    before_create :reduce_inventory
    before_destroy :restore_inventory, if: -> { order.status_pending? }
  
    def total_price
      quantity * unit_price
    end
  
    def inventory_item
      variant || product
    end
  
    def reduce_inventory
      inventory_item.decrement!(:stock_quantity, quantity)
    end
  
    def restore_inventory
      inventory_item.increment!(:stock_quantity, quantity)
    end
  end