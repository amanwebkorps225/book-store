class UsersController < ApplicationController 
  load_and_authorize_resource
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    if current_user
                # ActiveRecord::Base.connection.execute("SELECT `users`.* FROM `users`")
             @users = User.all
            #  render json: @user
             render json: { user: @users }
          
    else
      render json: { message: "Login first as admin and then access this page."}, status: :unprocessable_entity
    end
    
  end

  # GET /users/1
  def show
    render json: @user
    # return render json: { user: user_info } if able_to_show
  end

  # POST /users
  def create
    
    if current_user.role == "admin"
      @user = User.new(user_params)    
      @user.save
      render json: @user, status: :created, location: @user
    else
      render plain: @user.errors.full_messages
      render json: @user.errors, status: :unprocessable_entity
    end
  end
# ------------------------------

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
          show_info({"message" => "Deleted successfully"})

  end
  
   # /profile
  def profile
    if current_user.role == "client"
      show_info({"message" => "#{current_user.email}! Welcome to the Book Store API", "user" => book_bought_data})
    elsif current_user.role == "admin"
      show_info({"message" => "#{current_user.email}! Welcome to the Book Store API login as client to see all buy book" })
    else
     show_info({"message" => "Welcome to the API", "prompt" => "Please Login as to perform api actions."})
    end

  end
  
   

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])

    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit( :email,:role)
    

    end

    # show data of  Books bought by current User
    def book_bought_data
       if user_client
         cilent_data = {
            id: current_user.id,
            email: current_user.email,
            booksbought: boughts_books(current_user)
        }
        return cilent_data
       end

    end
end