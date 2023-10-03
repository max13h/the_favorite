class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_signed_in_and_no_family
  before_action :allow_set_session_origin_path

  include Pundit::Authorization

  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def allow_set_session_origin_path
    @allowed_previous_path = [
      "/home/tasks",
      "/home/events",
      "/competitions",
      "/common-pot",
      "/kids"
    ]

    referrer = URI.parse(request.referrer).path if request.referrer
    current = request.path if request.path

    is_allowed = @allowed_previous_path.any? { |substring| referrer =~ /#{Regexp.escape(substring)}\z/ }

    from_competition_show_to_event_show = (referrer =~ /\/competitions\/\d+\z/) && (current =~ /\/events\/\d+\z/)
    from_event_show_to_competition_show = (referrer =~ /\/events\/\d+\z/) && (current =~ /\/competitions\/\d+\z/)

    from_competition_show_to_task_show = (referrer =~ /\/competitions\/\d+\z/) && (current =~ /\/tasks\/\d+\z/)
    from_task_show_to_competition_show = (referrer =~ /\/tasks\/\d+\z/) && (current =~ /\/competitions\/\d+\z/)

    from_kid_show_to_task_show = (referrer =~ /\/kids\/\d+\z/) && (current =~ /\/tasks\/\d+\z/)
    from_task_show_to_kid_show = (referrer =~ /\/tasks\/\d+\z/) && (current =~ /\/kids\/\d+\z/)

    if from_competition_show_to_event_show
      session[:top_origin_path] = session[:origin_path]
      session[:origin_path] = request.referrer
    elsif from_event_show_to_competition_show
      session[:origin_path] = session[:top_origin_path]
      session.delete(:top_origin_path)
    elsif from_competition_show_to_task_show
      session[:top_origin_path] = session[:origin_path]
      session[:origin_path] = request.referrer
    elsif from_task_show_to_competition_show
      session[:origin_path] = session[:top_origin_path]
      session.delete(:top_origin_path)
    elsif from_kid_show_to_task_show
      session[:top_origin_path] = session[:origin_path]
      session[:origin_path] = request.referrer
    elsif from_task_show_to_kid_show
      session[:origin_path] = session[:top_origin_path]
      session.delete(:top_origin_path)
    elsif is_allowed
      session[:origin_path] = request.referrer
    end
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(_resource)
    home_tasks_path
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
    pages_actions = ["root", "home_tasks", "home_events", "common_pot"]
    devise_controller? || pages_actions.include?(params[:action])
  end
end
