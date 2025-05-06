# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with appropriate params' do
    user = described_class.new(
      birth_date: '2000-01-01', phone_number: '00000000000', email: 'jon@example.com', password: 'jontest1'
    )
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end

  it 'is invalid without a password' do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include('を入力してください')
  end

  it 'is invalid without a birth_date' do
    user = FactoryBot.build(:user, birth_date: nil)
    user.valid?
    expect(user.errors[:birth_date]).to include('を入力してください')
  end

  it 'is invalid without a phone_number' do
    user = FactoryBot.build(:user, phone_number: nil)
    user.valid?
    expect(user.errors[:phone_number]).to include('を入力してください')
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user)
    other_user = FactoryBot.build(:user)
    other_user.valid?
    expect(other_user.errors[:email]).to include('はすでに存在します')
  end

  it 'is invalid without a password is 6 characters or more' do
    user = FactoryBot.build(:user, password: 'a' * 5)
    user.valid?
    expect(user.errors[:password]).to include('は6文字以上で入力してください')
  end
end
