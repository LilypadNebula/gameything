# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render json: {success:true,user:resource}
      else
        expire_data_after_sign_in!
        render json: {success:true,user:resource}
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # puts resource.methods - Object.methods
      render json: {success:false,errors:resource.errors.full_messages}
    end
  end

end
