class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: UserBlueprint.render_as_json(User.find(current_user.id))
  end
end
