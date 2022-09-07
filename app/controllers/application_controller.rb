# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::API
  before_action :authenticate_user! # for internal server errors, this will check whether user is logged in or not

  rescue_from CanCan::AccessDenied do
    render json: { message: 'You are not authorized for this!' }
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordNotUnique, with: :render_not_unique_response
  rescue_from ActionController::ParameterMissing, with: :render_no_parameter_response

  # handling exception
  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_not_unique_response
    # render json: { error: exception.message }, status: 409
    render json: {
      message: 'This data is already present'
      # error:  exception.message
    }, status: 409
  end

  def render_no_parameter_response
    render json: {
      message: 'param is missing or the value is empty'
      #  error:  exception.message
    }, status: 400
  end

  def routing_error
    # render_exception(404, "Routing Error", exception)
    render json: {
      message: 'please check url no route matches'
    }, status: :not_found
  end

  def check_user_params
    params[:user].present?
  end

  def show_info(response)
    render json: response, status: 200
  end

  # check role
  def user_client
    current_user.role == 'client'
  end

  def user_admin
    current_user.role == 'admin'
  end

  # check
  def data_books(user)
    # this method data_book show data of all books whichare created by admin (in home controller)
    bookdata = []
    user.books.each do |book|
      bookdata << {
        Bookid: book.id,
        BookName: book.name,
        Author: book.author,
        Price: book.price,
        Quantity: book.quantity
        # url: notice_url(notice),
        # created_at: notice.created_at,
        # updated_at: notice.updated_at
      }
    end
    bookdata
  end

  # -------------------------------------
  def boughts_books(user)
    buy = []
    user.boughts.each do |bought|
      buy << {
        book_id: bought.book.id,
        book_name: bought.book.name,
        book_author: bought.book.author,
        book_price: bought.book.price
      }
    end
    buy
  end

  # -------------------------------------
  def all_books
    data = []
    @a = Book.all
    @a.each do |book|
      data << {
        book_id: book.id, book_name: book.name, book_author: book.author,
        book_price: book.price,available_quantity: book.quantity
      }
    end
    data
  end

  # -----------------------------------
end
