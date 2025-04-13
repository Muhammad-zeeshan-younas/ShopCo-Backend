class Review < ApplicationRecord
  after_save :update_product_rating
  after_destroy :update_product_rating

  belongs_to :user
  belongs_to :product

  validates :comment, presence: true
  validates :rating, presence: true, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 5 
  }
  
  private

  def update_product_rating
    product.update_average_rating
  end
end
