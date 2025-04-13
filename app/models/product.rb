class Product < ApplicationRecord
  has_many :variants, class_name: 'ProductVariant', dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :images
  accepts_nested_attributes_for :variants, allow_destroy: true
  
  before_save :update_in_stock_status
  before_create :set_default_position
  before_validation :generate_slug
  
  validates :name, :price, :category, :sku, presence: true
  validates :sku, uniqueness: true
  validates :slug, uniqueness: true
  
  scope :new_products, -> { where(is_new: true) }
  scope :top_sellers, -> { where(is_top_seller: true) }
  scope :discounted, -> { where(is_discounted: true) }

  # Public method to update rating that can be called from Review model
  def update_average_rating
    average = reviews.average(:rating)
    update_column(:rating, average ? average.round(2) : nil)
  end
  
  private
  
  def update_in_stock_status
    self.in_stock = stock_quantity > 0
  end
  
  def set_default_position
    self.position ||= Product.maximum(:position).to_i + 1
  end
  
  def generate_slug
    self.slug ||= name.parameterize
  end
end