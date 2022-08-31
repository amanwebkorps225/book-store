# frozen_string_literal: true

# profile controller
class ProfileController < ApplicationController
  # load_and_authorize_resource
  def data
    if current_user.role == 'client'
      show_info({ 'message' => "#{current_user.email}! Welcome to the Book Store API ",
                  'user' => book_bought_data })
    elsif current_user.role == 'admin'
      show_info({ 'message' => "#{current_user.email}! login as client to see all buy book",
                  'user' => book_bought_data })
    else
      show_info({ 'message' => 'Welcome to the ces API',
                  'prompt' => 'Please Login as to perform api actions.' })
    end
  end

  private

  def book_bought_data
    if user_client
      cilent_data = { id: current_user.id, email: current_user.email, booksbought: boughts_books(current_user) }
      return cilent_data
    end
    if user_admin
      admin_data = { id: current_user.id, email: current_user.email, All_books: all_books }
      return admin_data
    end
  end
end
