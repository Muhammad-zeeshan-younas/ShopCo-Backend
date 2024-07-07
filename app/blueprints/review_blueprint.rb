class ReviewBlueprint < Blueprinter::Base
  identifier :id

  fields :product_id, :comment, :rating, :created_at, :updated_at

  association :user, blueprint: UserBlueprint do |review|
    review.user
  end
end
