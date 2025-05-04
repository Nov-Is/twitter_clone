# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:login_params) { { user: { email: user.email, password: user.password } } }

  before do
    ActionMailer::Base.deliveries.clear

    user.confirm
    sign_in user
  end

  describe 'Post /posts' do
    # rubocop:disable RSpec/MultipleExpectations
    context 'when the params are appropriate' do
      it 'creates a new post' do
        content = 'a' * 140
        post posts_path, params: { post: { content: } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        expect(Post.count).to eq 1
      end
    end
    # rubocop:enable RSpec/MultipleExpectations

    context 'when the params are inappropriate' do
      it 'fails to create a new posts with more than 140 characters' do
        over_content = 'a' * 141
        post posts_path, params: { post: { content: over_content } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
