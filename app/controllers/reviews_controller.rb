class ReviewsController < ApplicationController
  def index
    @reviews = Review.includes(:user).all
    render json: ReviewBlueprint.render(@reviews)
  end
end
