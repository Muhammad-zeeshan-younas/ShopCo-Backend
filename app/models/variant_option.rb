class VariantOption < ApplicationRecord
    belongs_to :variant, class_name: 'ProductVariant', foreign_key: 'variant_id'

    validates :option_type, :value, presence: true
    validates :option_type, uniqueness: { scope: :variant_id }
  end