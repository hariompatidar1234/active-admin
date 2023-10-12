class UsersController < ApplicationController
  before_action :authenticate_request, except: %i[create login forgot_password reset_password]

  def index
    render json: User.all, status: :ok
  end

  def create
    user = User.new(user_params)

    if user.save
      # UserMailer.with(user: user).welcome_email.deliver_now
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @current_user, status: :ok
  end

  def update
    if @current_user.update(user_params)
      render json: { data: @current_user, message: 'User updated' }
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
      @current_user.destroy
      render json: { data: @current_user, message: 'User deleted' }
  end

  def login
    user = User.find_by(email: params[:email], password: params[:password])
    if user
      token = jwt_encode(user_id: user.id)
      render json: { message: 'Logged In Successfully', token: token },status: :ok
    else
      render json: { error: 'Please Check your Email and Password' }, status: :unauthorized
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])
    if user
      reset_password_token = SecureRandom.hex(13)
      reset_password_sent_at = Time.now
      user.update(reset_password_token: reset_password_token, reset_password_sent_at: reset_password_sent_at)
      UserMailer.with(user: user).forgot_password_token.deliver_now
      render json: { message: 'Password reset instructions sent.' }, status: :ok
    else
      render json: { error: 'Correct mail must be require' }, status: :not_found
    end
  end

  def reset_password
    return render json: { error: 'Token not present' } if params[:email].blank?

    user = User.find_by(reset_password_token: params[:token])
    if user && user.reset_password_sent_at > 2.hours.ago
      user.update(password: params[:password], reset_password_token: nil, reset_password_sent_at: nil)
      render json: { message: 'password reset Successfully' }, status: :ok
    else
      render json: { errors: 'invalid and token expired' } , status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :type, :image)
  end
end
