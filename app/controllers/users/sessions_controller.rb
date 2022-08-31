# frozen_string_literal: true

# user
module Users
  # session controller
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if current_user
        # UserMailer.signin(current_user).deliver_later   #for mailing
        render json: { message: 'You are logged in.' }, status: :ok

      else
        render json: { message: 'not logged in. ' }, status: :unprocessable_entity
      end
    end

    def respond_to_on_destroy
      log_out_success && return if current_user

      log_out_failure
    end

    def log_out_success
      render json: { message: 'You are logged out.' }, status: :ok
    end

    def log_out_failure
      render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
    end
  end
end
