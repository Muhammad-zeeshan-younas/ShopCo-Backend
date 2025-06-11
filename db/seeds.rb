require 'open-uri'

puts "Clearing existing data..."
[Review, Variant, Product, User].each do |model|
  model.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
end

NUM_USERS = 5
NUM_PRODUCTS = 10
MAX_VARIANTS_PER_PRODUCT = 3
MAX_IMAGES_PER_PRODUCT = 2
MAX_REVIEWS_PER_PRODUCT = 3

SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL']
COLORS = ['Red', 'Blue', 'Green', 'Black', 'White']
CATEGORIES = ['clothing', 'electronics', 'home', 'furniture', 'accessories']

puts "Creating #{NUM_USERS} users..."
users = NUM_USERS.times.map do
  User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number,
    password: 'password123'
  )
end

puts "Creating #{NUM_PRODUCTS} products..."
products = NUM_PRODUCTS.times.map.with_index do |_, i|
  discount_percentage = [true, false].sample ? Faker::Number.between(from: 10, to: 50) : nil

  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    base_price: Faker::Commerce.price(range: 10.0..100.0).round(2),
    category: CATEGORIES.sample,
    sku: "BASE-#{Faker::Alphanumeric.unique.alphanumeric(number: 6).upcase}",
    discount_percentage: discount_percentage,
    featured: i < 3
  )
end

puts "Creating variants for all products..."
products.each do |product|
  variant_count = rand(1..MAX_VARIANTS_PER_PRODUCT)
  
  used_combinations = Set.new

  variant_count.times do |i|
    # Ensure unique size/color combo per product variant
    size = SIZES.sample
    color = COLORS.sample
    while used_combinations.include?([size, color])
      size = SIZES.sample
      color = COLORS.sample
    end
    used_combinations.add([size, color])

    Variant.create!(
      product: product,
      size: size,
      color: color,
      sku_suffix: "#{product.sku}-#{i+1}",
      price_adjustment: Faker::Number.between(from: 0, to: 10.0).round(2),
      stock_quantity: Faker::Number.between(from: 5, to: 50)
    )
  end
end

puts "Attaching product images..."
products.each do |product|
  rand(1..MAX_IMAGES_PER_PRODUCT).times do
    begin
      image_url = "https://picsum.photos/800/800?random=#{rand(1000)}"
      product.images.attach(
        io: URI.open(image_url),
        filename: "product_#{product.id}.jpg",
        content_type: 'image/jpeg'
      )
    rescue => e
      puts "Failed to attach image to product #{product.id}: #{e.message}"
    end
  end
end

puts "Creating reviews for each product..."
products.each do |product|
  rand(1..MAX_REVIEWS_PER_PRODUCT).times do
    Review.create!(
      user: users.sample,
      product: product,
      comment: Faker::Lorem.sentences(number: 2).join(' '),
      rating: Faker::Number.between(from: 1, to: 5)
    )
  end
end

puts "Calculating average ratings..."
Product.includes(:reviews).find_each do |product|
  average = product.reviews.average(:rating)
  product.update!(rating: average.round(2)) if average
end

puts "\nSeed data complete!"
puts "=== Summary ==="
puts "Users: #{User.count}"
puts "Products: #{Product.count}"
puts "Variants: #{Variant.count}"
puts "Reviews: #{Review.count}"
puts "Total stock: #{Variant.sum(:stock_quantity)}"
