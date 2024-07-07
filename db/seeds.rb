# db/seeds.rb


# Seed Users
5.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number,
    avatar: Faker::Avatar.image,
    password_digest: BCrypt::Password.create('password')
  )

  # Seed Reviews for Users
  3.times do
    product = Product.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price: Faker::Commerce.price(range: 50.0..300.0),
      stock_quantity: Faker::Number.between(from: 0, to: 100),
      category: Faker::Commerce.department(max: 1),
      sku: Faker::Alphanumeric.alpha(number: 10),
      image_url: Faker::Avatar.image(size: "300x300")
    )

    user.reviews.create!(
      product: product,
      rating: Faker::Number.between(from: 1, to: 5),
      comment: Faker::Lorem.sentence(word_count: 10)
    )
  end
end

puts 'Users and their reviews seeded successfully'

puts 'Products and their reviews seeded successfully'
