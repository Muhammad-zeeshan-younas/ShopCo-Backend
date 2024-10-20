# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
    render json: ProductBlueprint.render( @products)
  end

  # GET /products/1
  def show
    render json: ProductBlueprint.render(@product)
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_sku(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :stock_quantity, :category, :sku, :image_url)
    end
end
