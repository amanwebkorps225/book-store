class HomeController < ApplicationController
  def home
    if current_user.role == "admin"
      show_info({"message" => "#{current_user.email}! Welcome to the Book Store API", "user" => admin_user_data})
    elsif current_user.role == "client"
        show_info({"message" => "#{current_user.email}! Welcome to the Book Store ", "user_info" => client_user_data})
    else
     show_info({"message" => "Welcome to the Student Notices API", "prompt" => "Please Login to perform api actions."})
    end
  end
 # -------------------------------------

   def buybook
        if current_user.role == "client"
          @boughtbook = Bought.new(bought_params)
          @boughtbook.user_id=current_user.id
    
                if @boughtbook.save
                  # render json: @boughtbook, status: :created, location: @boughtbook
                  UserMailer.buybook(current_user).deliver_later   # mail buy book                               
                  render json: @boughtbook, status: :created, location: @boughtbook

                else
                  render json: @boughtbook.errors, status: :unprocessable_entity
                end
        else
            render json: { message: "Login first to access this page."}, status: :unprocessable_entity
        end

   end
   
 #------------------------------------------  


  private

  def bought_params
      params.require(:bought).permit(:buybook, :book_id)
  end
  # Creating user information in json
  
  def admin_user_data
    data = {
      id: current_user.id,
      email: current_user.email
    
    }
    
    if user_admin 
        data = {
        id: current_user.id,
        email: current_user.email,
       
        books: data_books(current_user) # this method data_book show data of all books whichare created by admin
      }
     end
    
     return data
    end

    #---------------------------------------------
    def client_user_data
       if user_client 
        data = {
         id: current_user.id,
         email: current_user.email,
         all_books: all_books()
        }
      end
    end
    #---------------------------------------
end