class Devise::Custom::RegistrationsController < Devise::RegistrationsController
  def edit
    super
  end

  def update
    super
  end

  private

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :picture, :password, :password_confirmation, :current_password)
  end
end
