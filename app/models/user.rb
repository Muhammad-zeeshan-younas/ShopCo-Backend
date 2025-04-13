class User < ApplicationRecord
        extend Devise::Models

        devise :database_authenticatable, :registerable,
                :recoverable, :rememberable, :trackable, :validatable,
                :omniauthable
        include DeviseTokenAuth::Concerns::User
  has_many :testimonials
  has_many :reviews
  has_one_attached :avatar
  
  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
end
