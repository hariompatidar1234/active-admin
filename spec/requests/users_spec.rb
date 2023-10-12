require 'rails_helper'
include JsonWebToken

RSpec.describe "Users", type: :request do
   let!(:user) { FactoryBot.build(:user) }
  let(:valid_jwt) { generate_valid_jwt(user) }
  # Define a method to generate a valid JWT token for a user
  def generate_valid_jwt(user)
    payload = { user_id: user.id }
    secret_key = Rails.application.secrets.secret_key_base
    JWT.encode(payload, secret_key)
  end

  describe 'GET /users' do
    it 'returns a list of users with valid JWT' do
      user.save
      get '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end


  describe 'POST /users' do
    it 'creates a new user' do
      post '/users', params: { name: user.name,email: user.email,password: user.password, type: user.type }
      expect(response).to have_http_status(:created)
    end
    it 'returns unprocessable entity with error messages' do
      invalid_user_attributes = { name: 'John' } # Missing required email and password
      post '/users', params: invalid_user_attributes.to_json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /profile' do
    it 'show user profile' do
      user.save
      get '/profile',  headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /profile' do
    it "update user" do
      user.save
      put '/profile' , headers: { 'Authorization' => "Bearer #{valid_jwt}"},params: {name: "hariom",email: "hariom@123gmail.com",password: "1234567"}
      expect(response).to have_http_status(:ok)
    end
    it 'returns unprocessable_entity without a valid JWT' do
      user.save
        put '/profile', params: {name: nil ,email: nil} , headers: { 'Authorization' => "Bearer #{valid_jwt}"}
        expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /profile' do
    it 'it should destroy user account' do
      user.save
      delete '/profile', headers: { 'Authorization' => "Bearer #{valid_jwt}"}
      expect(response).to have_http_status :ok
    end
  end

  describe 'LOGIN /user/login' do
    it 'login user' do
      user.save
      post '/users/login' ,params: { user_id:user.id, email: user.email, password: user.password}
      expect(response).to have_http_status :ok
    end
     it 'returns unauthorized with invalid credentials' do
      post '/users/login',params: { email: '123@gmail.com', password: nil }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Forget password' do
    it 'forgfot password' do
      user.save
      post '/users/forgot_password',params: {email: user.email}
      expect(response).to have_http_status :ok
    end
    it 'not forgfot' do
        post '/users/forgot_password',params: {email: nil}
    end
  end

  describe 'reset' do
    it 'reset password' do
      user.save
      reset_password_token = SecureRandom.hex(13)
      reset_password_sent_at = Time.now
      user.update(reset_password_token: reset_password_token, reset_password_sent_at: reset_password_sent_at)
      post '/users/reset_password', params: {token: reset_password_token, email: user.email}
      expect(response).to have_http_status :ok
    end
     it 'returns unauthorized with invalid credentials' do
       post '/users/reset_password' ,params: {token: nil, email: user.email}
      expect(response).to have_http_status :unprocessable_entity
    end
  end
end

