class BooksController < ApplicationController

load_and_authorize_resource

  before_action :authenticate_user!
  before_action :set_book, only: %i[ show update destroy ]

  # GET /books
  def index
    if current_user.role =="admin"
      @books = Book.all
      render json: @books
    elsif current_user.role =="client"
       @a = current_user
      @books = @a.books
      render json: @books
    else
    render json: { message: "Login first to access this page."}, status: :unprocessable_entity
    end
  end

  # GET /books/1
  def show
    render json: @book
  end

  # POST /books
  def create

    if current_user
     

      @book = Book.new(book_params)
      @book.user_id=current_user.id
      

          if @book.save
            render json: @book, status: :created, location: @book
          else
            render json: @book.errors, status: :unprocessable_entity
          end
    else
    render json: { message: "Login first to access this page."}, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /books/1
  def update  
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      # params.fetch(:notice, {})
      params.require(:book).permit(:name, :author, :price ,:quantity)

    end
end