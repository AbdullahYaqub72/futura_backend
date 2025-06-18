class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_user
  attr_reader :current_user
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: 'Access Denied' }, status: :forbidden
  end

  private
  def set_current_user
    token = request.headers['Authorization']&.split(' ')&.last
    return unless token

    user_info = SupabaseService.get_user_info(token)

    if user_info && user_info["id"]
      @current_user = User.find_by(supabase_id: user_info["id"])
    else
      @current_user = nil
    end
  end
end
