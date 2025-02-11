# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable, :confirmable, :timeoutable, :omniauthable, omniauth_providers: %i[github]

  validates :phone_number, :birth_date, presence: true
  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? }

  # 自分がフォローしている人
  has_many :relationships, foreign_key: :followee_id, dependent: :destroy, inverse_of: :relationship
  has_many :followees, through: :relationships, source: :follower
  # 自分をフォローしている人
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy,
                                      inverse_of: :relationship
  has_many :followers, through: :reverse_of_relationships, source: :followee

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :icon_image
  has_one_attached :header_image

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

  delegate :count, to: :followees, prefix: true

  delegate :count, to: :followers, prefix: true

  def following_posts_with_reposts
    following_posts_relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.repostable_id
                                          AND (reposts.user_id = #{id} OR reposts.user_id
                                          IN (SELECT followee_id FROM relationships WHERE followee_id = #{id}))")
                                   .where('reposts.repostable_type = ? OR reposts.repostable_type IS NULL', 'Post')
                                   .select('posts.*, reposts.user_id AS repost_user_id,
                                          (SELECT name FROM users WHERE id = reposts.user_id) AS repost_user_name')
    following_posts_relation.where(user_id: followings_with_userself.pluck(:id))
                            .or(following_posts_relation.where(id:
                                Repost.where(user_id: followings_with_userself.pluck(:id))
                                .distinct.pluck(:repostable_id)))
                            .where('NOT EXISTS(SELECT 1 FROM reposts sub
                                    WHERE reposts.repostable_id = sub.repostable_id
                                    AND reposts.created_at < sub.created_at)')
                            .with_attached_images
                            .preload(:user, :comments, :favorites, :reposts)
                            .order(Arel.sql('CASE WHEN reposts.created_at IS NULL THEN posts.created_at
                                            ELSE reposts.created_at END DESC'))
  end

  def followings_with_userself
    User.where(id: followees.pluck(:id)).or(User.where(id:))
  end

  def recommend_posts_with_reposts
    recommend_posts_relation = Post.joins('LEFT OUTER JOIN reposts on posts.id = reposts.repostable_id')
                                   .where('reposts.repostable_type = ? OR reposts.repostable_type IS NULL', 'Post')
                                   .select('posts.*, reposts.user_id AS repost_user_id,
                                   (SELECT name FROM users WHERE id = reposts.user_id) AS repost_user_name')
    recommend_posts_relation
      .where('NOT EXISTS(SELECT 1 FROM reposts sub WHERE reposts.repostable_id = sub.repostable_id
              AND reposts.created_at < sub.created_at)')
      .with_attached_images
      .preload(:user, :comments, :favorites, :reposts)
      .order(Arel.sql('CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END DESC'))
  end
end
