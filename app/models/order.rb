# app/models/order.rb
class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items, dependent: :destroy
    has_many :products, through: :order_items
    has_many :variants, through: :order_items
  
    enum status: {
      pending: 0,       # Order placed but not processed
      processing: 1,    # Payment confirmed, preparing for shipment
      shipped: 2,       # Items shipped to customer
      delivered: 3,     # Customer received items
      rejected: 4       # Order was cancelled/rejected
    }, _prefix: true
  
    validates :total, numericality: { greater_than_or_equal_to: 0 }
  
    before_update :manage_inventory_transition, if: :status_changed?
  
    def add_product(product, variant: nil, quantity: 1)
      order_items.create!(
        product: product,
        variant: variant,
        quantity: quantity,
        unit_price: variant ? variant.final_price : product.discounted_price
      )
      update_total!
    end
  
    def update_total!
      update!(total: order_items.sum('quantity * unit_price'))
    end
  
    private
  
    def manage_inventory_transition
      if status_rejected?
        restore_inventory
      elsif status_was == 'rejected' && !status_rejected?
        reduce_inventory
      end
    end
  
    def restore_inventory
      order_items.each(&:restore_inventory)
    end
  
    def reduce_inventory
      order_items.each(&:reduce_inventory)
    end
  end