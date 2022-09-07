class HomeController < ApplicationController
  def home
    if current_user.role == "admin"
      show_info({ "message" => "#{current_user.email}! Welcome to the Book Store API", "user" => admin_user_data })
    elsif current_user.role == "client"
      show_info({ "message" => "#{current_user.email}! Welcome to the Book Store ", "user_info" => client_user_data })
    else
      show_info({ "message" => "Welcome to the Student Notices API", "prompt" => "Please Login to perform api actions." })
    end
  end

  # ---------------------------------- ---
  require("stripe")

  Stripe.api_key = "sk_test_51LdF69SHRZRDvthmnL6PP8xADFLOElOWsKiok3v5SaUwnXN1bDZJeowpsGzDI4XACPTAUDHEhBWnP4k0wb4OqAKo00b88sgcdC"

  def buybook #  to buy book
    if current_user.role == "client"
      @boughtbook = Bought.new(bought_params)
      @boughtbook.user_id = current_user.id

      if @boughtbook.quantity <= Book.find(@boughtbook.book_id).quantity
        book_save(@boughtbook)  # save book data
      else
        render json: { message: "currently this quantity is not in stock" } #, status: :unprocessable_entity
      end
    else
      render json: { message: "Login first to access this page." }, status: :unprocessable_entity
    end
  end

  #------------------------------------------ ---------------------------

  private

  def bought_params
    params.require(:bought).permit(:buybook, :book_id, :quantity)
  end

  # Creating user information in json

  def admin_user_data
    data = {
      id: current_user.id,
      email: current_user.email,

    }

    if user_admin
      data = {
        id: current_user.id,
        email: current_user.email,

        books: data_books(current_user), # this method data_book show data of all books whichare created by admin
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
        all_books: all_books(),
      }
    end
  end

  #---------------------------------------

  def book_save(boughtbook)
    if boughtbook.save
      # render json: @boughtbook, status: :created, location: @boughtbook
      # UserMailer.buybook(current_user).deliver_later   # mail buy book
      @book = Book.find(boughtbook.book_id)
      @book.quantity = (Book.find(@boughtbook.book_id).quantity) - (boughtbook.quantity)
      @price = (@book.price)*100
      @quantity = boughtbook.quantity
      
      book_payment(@price ,@quantity)    #paymentmethod

      @book.save
      render json: boughtbook, status: :created, location: boughtbook
    else
      render json: boughtbook.errors, status: :unprocessable_entity
    end
  end

  #--------------

  def book_payment(amt ,quant)
    price = Stripe::Price.create({
      unit_amount: (amt),
      currency: "inr",
      product: "prod_MM0G56CDdOlPV3",     #Hellen keller book ==  prod_MMIBplDzaG2zmE
    })

    order = Stripe::PaymentLink.create(
      line_items: [{ price: price.id, quantity: quant }],
      after_completion: { type: "redirect", redirect: { url: "https://dashboard.stripe.com/test/payments" } },
    )
    system("xdg-open", order.url)
  end

  #---------------
end
