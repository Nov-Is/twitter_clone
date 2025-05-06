# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_params) { FactoryBot.attributes_for(:user) }
  let(:invalid_user_params) { FactoryBot.attributes_for(:user, email: nil) }
  let(:user) { FactoryBot.create(:user) }
  let(:login_params) { { user: { email: user.email, password: user.password } } }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe 'Post /users/sign_up' do
    context 'with valid params' do
      it 'successfully signs up' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not sign up' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end
    end
  end

  describe 'Post /users/sign_in' do
    context 'with valid credentials' do
      it 'successfully signs in' do
        user.confirm
        post user_session_path, params: login_params
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in with invalid email' do
        user.confirm
        login_params[:user][:email] = nil
        post user_session_path, params: login_params
        get root_path
        expect(response).to be_unauthenticated
      end

      it 'does not sign in with invalid password' do
        user.confirm
        login_params[:user][:password] = nil
        post user_session_path, params: login_params
        get root_path
        expect(response).to be_unauthenticated
      end

      it 'does not sign in due to unconfirmation' do
        post user_session_path, params: login_params
        get root_path
        expect(response).to be_unauthenticated
      end
    end
  end
end
