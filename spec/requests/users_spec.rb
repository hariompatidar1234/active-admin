require 'rails_helper'
include JsonWe  bToken

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
      get '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      # ... Other expectations ...
    end
    it 'returns unprocessable_entity with invalid JWT' do
      get '/users', headers: { 'Authorization' => 'Bearer invalid_token' }
      expect(response).to have_http_status(:unprocessable_entity)
      # ... Other expectations ...
    end
  end


  describe 'POST /users' do
    context 'with valid user attributes and valid JWT' do
      it 'creates a new user' do
        # user_attributes = FactoryBot.create(:user)
        user_attributes = FactoryBot.build(:user)
        post '/users', params: { name: user_attributes.name,email: user_attributes.email,password: user_attributes.password, type: user_attributes.type }, headers: { 'Authorization' => "Bearer #{valid_jwt}"}
        expect(response).to have_http_status(:created)
      end
    end
    context 'with invalid user attributes and valid JWT' do
      it 'returns unprocessable entity with error messages' do
        user_attributes = FactoryBot.build(:user)
        invalid_user_attributes = { name: 'John' } # Missing required email and password
        post '/users', params: invalid_user_attributes.to_json, headers: { 'Authorization' => "Bearer #{valid_jwt}"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Email can\'t be blank')
        expect(response.body).to include('Password can\'t be blank')
      end
    end
  end

  # describe 'GET /users' do
  #   context 'with valid user attributes and valid JWT' do
  #     it 'creates a new user' do
  #       # user_attributes = FactoryBot.build(:user)
  #       get '/profile',  headers: { 'Authorization' => "Bearer #{valid_jwt}" }
  #       byebug
  #       expect(response).to have_http_status(200)
  #     end
  #   end
  # end
end
