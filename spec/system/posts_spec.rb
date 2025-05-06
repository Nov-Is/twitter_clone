# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)

    visit root_path
    click_button 'ログイン'
    user.confirm
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  it 'fails to post a content' do
    fill_in 'post_content', with: nil
    click_button 'ポストする'
    expect(page).to have_content('ポストできませんでした。')
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'successfully posts a content' do
    fill_in 'post_content', with: 'テスト投稿です！'
    attach_file 'post_images', Rails.root.join('app/assets/images/40x40.png').to_s
    click_button 'ポストする'
    expect(page).to have_content('ポストを送信しました。')
    expect(page).to have_content('テスト投稿です！')
  end
  # rubocop:enable RSpec/MultipleExpectations
end
