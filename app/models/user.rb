class User < ApplicationRecord
  has_many :testimonials
  has_many :reviews
  has_one_attached :avatar
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone, presence: true
end
