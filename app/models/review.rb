class Review < ApplicationRecord
  after_save :update_product_rating
  after_destroy :update_product_rating

  belongs_to :user
  belongs_to :product

  validates :comment, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  
  private

  def update_product_rating
    product.update_rating
    product.save
  end
end
