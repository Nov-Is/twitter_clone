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
  has_many :relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy,
                           inverse_of: :follower
  has_many :followings, through: :relationships, source: :followed
  # 自分をフォローしている人
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy,
                                      inverse_of: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # active_notifications：自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy,
                                  inverse_of: :visitor
  # passive_notifications：相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy,
                                   inverse_of: :visited

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
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

  delegate :count, to: :followings, prefix: true

  delegate :count, to: :followers, prefix: true

  def following_posts_with_reposts
    following_posts_relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.repostable_id
                                          AND (reposts.user_id = #{id} OR reposts.user_id
                                          IN (SELECT followed_id FROM relationships WHERE followed_id = #{id}))")
                                   .posts_only
                                   .with_posts_and_related_info
    followings_with_userself_ids = followings_with_userself.pluck(:id)
    following_posts_relation
      .where(user_id: followings_with_userself_ids)
      .or(following_posts_relation.where(id:
          Repost.where(user_id: followings_with_userself_ids)
          .distinct.pluck(:repostable_id)))
      .latest_reposts
      .then { |relation| with_all_preloads(relation) }
  end

  def followings_with_userself
    User.where(id: followings.ids + [id])
  end

  def recommend_posts_with_reposts
    recommend_posts_relation = Post.joins('LEFT OUTER JOIN reposts on posts.id = reposts.repostable_id')
                                   .posts_only
                                   .with_posts_and_related_info
    recommend_posts_relation
      .latest_reposts
      .then { |relation| with_all_preloads(relation) }
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def create_notification_follow(current_user)
    relationship = Relationship.find_by(follower_id: current_user.id, followed_id: id)
    followed = Notification.where(['visitor_id = ? and visited_id = ? and
                                    notifiable_type = ? and notifiable_id = ? and action = ?',
                                   current_user.id, id, Relationship, relationship.id, 'follow'])
    return if followed.present?

    notification = current_user.active_notifications.new(
      notifiable_id: relationship.id,
      notifiable_type: Relationship,
      visited_id: id,
      action: 'follow'
    )

    notification.save if notification.valid?
  end

  private

  def with_all_preloads(relation)
    relation.with_attached_images
            .preload(:user, :comments, :favorites, :reposts)
            .order(Arel.sql('CASE WHEN reposts.created_at IS NULL THEN posts.created_at
                            ELSE reposts.created_at END DESC'))
  end
end
