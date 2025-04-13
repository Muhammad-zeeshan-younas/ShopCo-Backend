class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  
  def index
    @reviews = Review.includes(:user).all
    render json: ReviewBlueprint.render(@reviews)
  end

  def product_reviews
    product = Product.find(params[:product_id])
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 10

    reviews = product.reviews
                     .includes(:user)
                     .order(created_at: :desc)
                     .page(page)
                     .per(per_page)

    has_more = reviews.total_pages > page

    render json: {
      reviews: reviews.as_json(include: { user: { only: [:id, :username, :avatar] } }),
      current_page: page,
      has_more: has_more
    }, status: :ok
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      # Broadcast the new review to all subscribers
      broadcast_review(@review)
      render json: @review.as_json(include: { user: { only: [:id, :username, :avatar] } }), status: :created
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def broadcast_review(review)
    ReviewsChannel.broadcast_to(
      review.product,
      {
        action: 'new_review',
        review: review.as_json(include: { user: { only: [:id, :username, :avatar] } })
      }
    )
  end
end