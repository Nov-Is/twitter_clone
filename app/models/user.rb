# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable, :confirmable, :timeoutable, :omniauthable, omniauth_providers: %i[github]

  validates :phone_number, :birth_date, presence: true
  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? }
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                           inverse_of: :user
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy,
                                      inverse_of: :user
  has_one_attached :image

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.phone_number = '00000000000'
      user.birth_date = '2000-01-01'

      if user.persisted? || auth.provider == 'github'
        user.skip_confirmation! if auth.provider == 'github'
        user.save
      end
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
