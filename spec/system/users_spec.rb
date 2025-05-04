# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
  describe 'user signs up' do
    before do
      visit root_path
      click_link 'アカウント登録'
    end

    it 'fails to signs up' do
      click_button '登録する'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'パスワードを入力してください'
      expect(page).to have_content '電話番号を入力してください'
      expect(page).to have_content '生年月日を入力してください'
    end

    it 'successfully signs up' do
      expect do
        fill_in 'メールアドレス', with: 'jon@example.com'
        fill_in '電話番号', with: '00000000000'
        select '2000', from: 'user[birth_date(1i)]'
        select '1月', from: 'user[birth_date(2i)]'
        select '1', from: 'user[birth_date(3i)]'
        fill_in 'パスワード', with: 'jontest1'
        fill_in 'パスワード（確認用）', with: 'jontest1'
        click_button '登録する'
      end.to change(User, :count).by(1)
      expect(page).to have_current_path(new_user_session_path), ignore_query: true
    end
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations

  describe 'user signs in' do
    before do
      visit root_path
    end

    it 'fails to sign in due to no entered' do
      click_button 'ログイン'
      expect(page).to have_content('メールアドレスまたはパスワードが違います。')
    end

    it 'fails to sign in due to no confirmed' do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_content('メールアドレスの本人確認が必要です。')
    end

    it 'successfully signs in' do
      user.confirm
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました。')
    end
  end
end
