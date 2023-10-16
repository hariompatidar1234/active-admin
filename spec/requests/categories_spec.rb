require 'rails_helper'
include JsonWebToken
RSpec.describe "Categories", type: :request do
  let!(:category){ FactoryBot.create(:category) }
  let!(:user) { FactoryBot.create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }


  describe 'GET /categories/:category_id' do
    it 'list a category for user' do
      get "/categories", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /Categories" do
      it 'creates a category for owners' do
      owner = FactoryBot.create(:user, type: 'Owner')
      post '/categories', params:  { name: "indian" },  headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(201)
    end
    it 'returns an error for invalid category creation' do
      owner = FactoryBot.create(:user, type: 'Owner')
      post '/categories', params:  { name: nil },  headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /categories/:category_id' do
    it 'shows a category user' do
      get "/categories/#{category.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /categories/:category_id' do
    owner = FactoryBot.create(:user, type: 'Owner')
    it 'updates a category for owners' do
      put "/categories/#{category.id}", params: { name: "maxicon" }, headers: { 'Authorization' =>"Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for invalid category update' do
      put "/categories/#{category.id}", params: { name: nil }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /categories/:category_id' do
    it 'deletes a category for owners' do
      owner = FactoryBot.create(:user, type: 'Owner')
      delete "/categories/#{category.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
