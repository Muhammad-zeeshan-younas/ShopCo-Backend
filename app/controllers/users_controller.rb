class UsersController < ApplicationController
  has_secure_password

  has_many :reviews
end
