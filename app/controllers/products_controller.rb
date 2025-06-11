# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.with_attached_images
    .includes(:variants)
    .order(created_at: :desc)
    
    # Filtering examples
    @products = @products.where(category: params[:category]) if params[:category]
    @products = @products.where(featured: true) if params[:featured]
    @products = @products.where("base_price <= ?", params[:max_price]) if params[:max_price]

    render json: ProductBlueprint.render(@products, root: :products)
  end


  # GET /products/1
  def show
    render json: ProductBlueprint.render(@product)
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    
    if @product.save
      # Handle nested variant creation if present
      if params[:product][:variants_attributes].present?
        @product.variants.create!(params[:product][:variants_attributes])
      end
      
      render json: ProductBlueprint.render(@product, view: :detailed), 
             status: :created, 
             location: @product
    else
      render json: { errors: @product.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    # Handle variants updates
    if params[:product][:variants_attributes].present?
      update_variants(params[:product][:variants_attributes])
    end
    
    if @product.update(product_params)
      render json: ProductBlueprint.render(@product, view: :detailed)
    else
      render json: { errors: @product.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    head :no_content
  end

  private
  
  def set_product
    @product =  Product.includes(:variants).find_by!(sku: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :stock_quantity, :category, 
      :sku, :image_url, :weight, :weight_unit, :is_new, 
      :is_top_seller, :is_discounted, :original_price, 
      :discount_percentage, :meta_title, :meta_description, 
      :position, :low_stock_threshold,
      variants_attributes: [
        :id, :name, :sku_suffix, :price_adjustment, :stock_quantity, :_destroy,
        options_attributes: [:id, :option_type, :value, :_destroy]
      ]
    )
  end
  
  def update_variants(variants_attributes)
    variants_attributes.each do |variant_params|
      if variant_params[:id].present?
        variant = @product.variants.find(variant_params[:id])
        if variant_params[:_destroy] == "1"
          variant.destroy
        else
          variant.update(variant_params.except(:_destroy))
        end
      else
        @product.variants.create(variant_params.except(:_destroy)) unless variant_params[:_destroy] == "1"
      end
    end
  end
end
