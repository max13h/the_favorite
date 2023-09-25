class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_signed_in_and_no_family

  include Pundit::Authorization

  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?



  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(_resource)
    home_path
  end

  private

  def redirect_if_signed_in_and_no_family
    if user_signed_in? && current_user.family.nil? && !on_allowed_path?
      redirect_to profile_path, alert: "Add your family to get full access to the app"
    end
  end

  def on_allowed_path?
    request.path == root_path || request.path == profile_path || request.path == destroy_user_session_path || request.path == edit_user_registration_path || request.path == new_family_path || request.path == join_family_path || request.path == create_family_path
  end

  def skip_pundit?
    pages_actions = ["root", "home", "common_pot"]
    devise_controller? || pages_actions.include?(params[:action])
  end
end
