class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :category, presence: true
  has_many_attached :images
  has_many :reviews, dependent: :destroy
  before_save :update_rating


  def update_rating
    self.rating = reviews.average(:rating) || 0.0
  end
end
