# Clear existing data
User.destroy_all
Product.destroy_all
Review.destroy_all

# Number of records to create
num_users = 10
num_products = 20
num_images_per_product = 4
num_reviews_per_product = 3

# Generate users with avatars
num_users.times do
  user = User.create!(
    username: Faker::Name.name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number,
    password: BCrypt::Password.create('password')
  )

  # Attach an avatar to the user
  avatar_url = Faker::Avatar.image
  user.avatar.attach(io: URI.open(avatar_url), filename: "#{user.username}_avatar.jpg")
end

# Generate products with images
products = []
num_products.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 1.0..100.0),
    stock_quantity: Faker::Number.between(from: 1, to: 100),
    category: Faker::Commerce.department,
    sku: Faker::Alphanumeric.unique.alphanumeric(number: 10),
  )

  # Attach multiple images to the product
  num_images_per_product.times do
    image_url = Faker::LoremFlickr.image
    product.images.attach(io: URI.open(image_url), filename: "#{product.name}_image.jpg")
  end

  products << product
end

# Generate reviews for products
products.each do |product|
  num_reviews_per_product.times do
    user = User.order('RANDOM()').first
    Review.create!(
      user: user,
      product: product,
      comment: Faker::Lorem.sentence(word_count: 10),
      rating: Faker::Number.between(from: 1, to: 5)
    )
  end
end

puts 'Dummy data generated successfully!'
