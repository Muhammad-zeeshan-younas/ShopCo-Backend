class ReviewsController < ApplicationController
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
end
