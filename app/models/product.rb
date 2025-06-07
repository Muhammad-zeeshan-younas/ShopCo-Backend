class Product < ApplicationRecord
  # Categories (like Shopify collections)
  CATEGORIES = %w[clothing electronics home furniture accessories].freeze

  # Associations
  has_many :variants, dependent: :destroy
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :base_price, numericality: { greater_than: 0 }
  validates :category, inclusion: { in: CATEGORIES }
  validates :sku, presence: true, uniqueness: true

  scope :featured, -> { where(featured: true) }
  scope :in_category, ->(category) { where(category: category) }
  scope :in_stock, -> { joins(:variants).where('variants.stock_quantity > 0').distinct }

  # Discount logic
  def discounted_price
    return base_price unless discount_percentage.present?
    base_price * (1 - discount_percentage / 100.0)
  end
  def update_average_rating
    average = reviews.average(:rating)
    update_column(:rating, average ? average.round(2) : nil)
  end
  

  # Stock management
  def total_stock
    variants.sum(:stock_quantity)
  end

  def in_stock?
    total_stock.positive?
  end
end