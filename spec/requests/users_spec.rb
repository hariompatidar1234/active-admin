require 'rails_helper'
include JsonWebToken

RSpec.describe "Users", type: :request do

  SECRET_KEY =Rails.application.secret_key_base
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) { jwt_encode(id: user.id) }

  describe "POST /create" do
    it "should create a event and returns a succesfull status" do
      request.headers['Authorization'] = "Bearer #{token}"
      post :create , params: { name: user.name, date: '12-12-2023', description: 'description' }
      expect(response.status).to eq(201)
    end
    it "should not create event when no params passed" do
      request.headers['Authorization'] = "Bearer #{hr_token}"
      post :create, params: { name: nil, date: nil, description: nil }
      expect(response.status).to eq(422)
    end
  end

    describe "GET /users" do
    it "works! (now write some real specs)" do
      get users_path
      expect(response).to have_http_status(200)
    end
  end
end
