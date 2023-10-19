require 'rails_helper'
include JsonWebToken

RSpec.describe 'Users', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }

  describe 'GET /users' do
    it 'returns a list of users with valid JWT' do
      get '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users' do
    it 'creates a new user' do
      post '/users', params: { name: 'hariom', email: 'hariom123@gmail.com', password: '123456', type: 'Owner' }
      expect(response).to have_http_status(:created)
    end
    it 'returns unprocessable entity with error messages' do
      post '/users', params: { name: 'John' }
      expect(response.status).to eql(422)
    end
  end

  describe 'GET /profile' do
    it 'show user profile' do
      get '/profile', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'show user profile' do
      get '/profile', headers: { 'Authorization' => "Bearer #{1234}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'show user profile' do
      get '/profile', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: 123456)}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /profile' do
    it 'update user' do
      put '/profile', headers: { 'Authorization' => "Bearer #{valid_jwt}" },
                      params: { name: 'hariom', email: 'hariom@123gmail.com', password: '1234567' }
      expect(response).to have_http_status(:ok)
    end
    it 'returns unprocessable_entity ' do
      put '/profile', params: { name: nil, email: nil }, headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response.status).to eql(422)
    end
  end

  describe 'DELETE /profile' do
    it 'it should destroy user account' do
      delete '/profile', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status :ok
    end
  end

  describe 'LOGIN /user/login' do
    it 'login user' do
      post '/users/login', params: { user_id: user.id, email: user.email, password: user.password }
      expect(response).to have_http_status :ok
    end
    it 'returns unauthorized with invalid credentials' do
      post '/users/login', params: { email: '123@gmail.com', password: nil }
      expect(response.status).to eql(403)
    end
  end

  describe 'Forget password' do
    it 'forgfot password' do
      post '/users/forgot_password', params: { email: user.email }
      expect(response).to have_http_status :ok
    end
    it 'not forgfot' do
      post '/users/forgot_password', params: { email: 'hariom' }
      expect(response.status).to eql(404)
    end
  end

  describe 'reset' do
    it 'reset password' do
      reset_password_token = SecureRandom.hex(13)
      reset_password_sent_at = Time.now
      user.update(reset_password_token: reset_password_token, reset_password_sent_at: reset_password_sent_at)
      post '/users/reset_password', params: { token: reset_password_token, email: user.email }
      expect(response).to have_http_status :ok
    end
    it 'returns unprocessable_entity with invalid credentials' do
      post '/users/reset_password', params: { token: 123, email: user.name }
      expect(response.status).to eql(422)
    end
  end
end
