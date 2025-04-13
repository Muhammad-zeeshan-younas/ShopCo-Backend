# db/seeds.rb
require 'open-uri'

# Clear data in proper order
puts "Clearing existing data..."
[Review, VariantOption, ProductVariant, Product, User].each do |model|
  model.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
end

# Constants
NUM_USERS = 5
NUM_PRODUCTS = 10
MAX_VARIANTS_PER_PRODUCT = 3
MAX_IMAGES_PER_PRODUCT = 2
MAX_REVIEWS_PER_PRODUCT = 3

# Sample data
COLORS = ['Red', 'Blue', 'Green', 'Black', 'White']
SIZES = ['S', 'M', 'L', 'XL']
MATERIALS = ['Cotton', 'Polyester', 'Wool']
CATEGORIES = ['Clothing', 'Electronics', 'Home']

# Create users
puts "Creating #{NUM_USERS} users..."
users = NUM_USERS.times.map do
  User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    password: 'password123'
  )
end

# Create products
puts "Creating #{NUM_PRODUCTS} products..."
products = NUM_PRODUCTS.times.map do |i|
  is_discounted = [true, false].sample
  original_price = is_discounted ? Faker::Commerce.price(range: 50.0..200.0) : nil
  discount_percentage = is_discounted ? Faker::Number.between(from: 10, to: 50) : nil

  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: is_discounted ? (original_price * (1 - discount_percentage / 100.0)).round(2) : Faker::Commerce.price(range: 10.0..100.0),
    stock_quantity: Faker::Number.between(from: 1, to: 100),
    category: CATEGORIES.sample,
    sku: Faker::Alphanumeric.unique.alphanumeric(number: 10).upcase,
    is_new: i < (NUM_PRODUCTS * 0.3),
    is_top_seller: [true, false].sample,
    is_discounted: is_discounted,
    original_price: original_price,
    discount_percentage: discount_percentage
  )
end

# Create variants and options
puts "Creating variants and options..."
products.each do |product|
  rand(1..MAX_VARIANTS_PER_PRODUCT).times do
    variant = ProductVariant.create!(
      product_id: product.id,
      name: Faker::Commerce.material,
      sku_suffix: "V#{Faker::Alphanumeric.alphanumeric(number: 2).upcase}",
      price_adjustment: Faker::Number.between(from: -5.0, to: 5.0).round(2),
      stock_quantity: Faker::Number.between(from: 1, to: 30)
    )

    # Create options using the correct foreign key
    VariantOption.create!(
      variant_id: variant.id,  # This must match your database column name
      option_type: 'color',
      value: COLORS.sample
    )

    if product.category == 'Clothing'
      VariantOption.create!(
        variant_id: variant.id,
        option_type: 'size',
        value: SIZES.sample
      )
    end
  end
end

# Attach images
puts "Attaching product images..."
products.each do |product|
  rand(1..MAX_IMAGES_PER_PRODUCT).times do
    begin
      image_url = "https://picsum.photos/300/300?random=#{rand(1000)}"
      downloaded_image = URI.open(image_url)
      product.images.attach(
        io: downloaded_image,
        filename: "product_#{product.id}.jpg",
        content_type: 'image/jpeg'
      )
    rescue => e
      puts "Failed to attach image: #{e.message}"
    end
  end
end

# Create reviews
puts "Creating reviews..."
products.each do |product|
  rand(1..MAX_REVIEWS_PER_PRODUCT).times do
    Review.create!(
      user_id: users.sample.id,
      product_id: product.id,
      comment: Faker::Lorem.sentence,
      rating: Faker::Number.between(from: 1, to: 5)
    )
  end
end

# Update ratings
puts "Updating product ratings..."
Product.all.each do |product|
  average = product.reviews.average(:rating)
  product.update(rating: average.round(2)) if average
end

puts "\nSeed data created successfully!"
puts "Users: #{User.count}"
puts "Products: #{Product.count}"
puts "Variants: #{ProductVariant.count}"
puts "Options: #{VariantOption.count}"
puts "Reviews: #{Review.count}"