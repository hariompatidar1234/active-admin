class ApplicationController < ActionController::API
  # Include JsonWebToken module for JWT handling
  include JsonWebToken

  # Before every action, authenticate the request using JWT
  before_action :authenticate_request

  # Authorize resource access using CanCanCan gem
  authorize_resource

  private

  def authenticate_request
    # byebug
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  # Access current_user as a read-only attribute
  attr_reader :current_user

  # Handle CanCanCan access denied
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end
end
