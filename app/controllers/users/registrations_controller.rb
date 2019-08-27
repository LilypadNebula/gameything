# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  # POST /users
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

   # PUT /users
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      render json: {success:true,user:resource}
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: {success:false,errors:resource.errors.full_messages}
    end
  end

end
