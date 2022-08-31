class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

# -------------------------------------------------------------------------------------------
def create
    # if the role of the current login user is admin then only create a user
    return not_authorized if !current_user
    if current_user.role == 'admin'
      if check_user_params
        build_resource(sign_up_params)

        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            # ----------------------------------------
            # UserMailer.welcome(resource).deliver_later  #for mailing
              #----------------------------------------  
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      else
        wrong_params
      end
    else
      # else send registration failed or not authorize message
      register_failed
    end
  end


#   ---------------------------------------------------------------------------------
  include RackSessionFix    #fix 505 error internal server error  session diable

  private

 def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'register  sucessfully.' }
  end

  def register_failed
    render json: { message: "Only Admin Can Create New User ---- OR ----- Check Your Data Format " }
  end

  def not_authorized
    render json: { message: 'You are not authorized for it! sign in as admin' }
  end
  
end