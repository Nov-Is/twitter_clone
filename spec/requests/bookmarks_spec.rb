# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarks', type: :request do
  describe 'GET /create' do
    it 'returns http success' do
      get '/bookmarks/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/bookmarks/destroy'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/bookmarks/show'
      expect(response).to have_http_status(:success)
    end
  end
end
