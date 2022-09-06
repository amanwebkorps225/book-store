class BoughtsController < ApplicationController 
load_and_authorize_resource

  before_action :authenticate_user!


# GET /boughts
  def index
    if current_user
      @boughts = Bought.all
      render json: @boughts
    else
    render json: { message: "Login first to access this page."}, status: :unprocessable_entity
    end
  end

end
