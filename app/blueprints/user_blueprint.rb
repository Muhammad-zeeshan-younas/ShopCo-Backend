class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :username, :email, :address, :phone

  field :avatar do |user, options|
    if user.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(user.avatar, host: Rails.application.routes.default_url_options[:host], port: Rails.application.routes.default_url_options[:port])
    else
      nil
    end
  end
end
