class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :comment, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
