# frozen_string_literal: true

class Post < ApplicationRecord
  include SharedLogic

  belongs_to :user
  has_many_attached :images
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :content, length: { maximum: 140 }

  scope :posts_only, lambda {
    where("reposts.repostable_type = 'Post' OR reposts.repostable_type IS NULL")
  }

  scope :with_posts_and_related_info, lambda {
    select('posts.*,
            reposts.user_id AS repost_user_id,
            (SELECT name FROM users WHERE id = reposts.user_id) AS repost_user_name')
  }

  scope :latest_reposts, lambda {
    where('NOT EXISTS(
      SELECT 1 FROM reposts sub
      WHERE reposts.repostable_id = sub.repostable_id
      AND reposts.created_at < sub.created_at
    )')
  }

  def create_notification_favorite(current_user, favorite)
    favored = Notification.where(['visitor_id = ? and visited_id = ?
                                  and notifiable_type = ? and notifiable_id = ? and action = ?',
                                  current_user.id, favorite.favorable.user_id, Post, favorite.favorable_id, 'favorite'])

    return if favored.present?

    notification = current_user.active_notifications.new(
      notifiable_id: favorite.favorable_id,
      notifiable_type: favorite.favorable_type,
      visited_id: favorite.favorable.user_id,
      action: 'favorite'
    )

    notification.read_at = favorite.created_at if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_repost(current_user, repost)
    favored = Notification.where(['visitor_id = ? and visited_id = ?
                                  and notifiable_type = ? and notifiable_id = ? and action = ?',
                                  current_user.id, repost.repostable.user_id, Post, repost.repostable_id, 'repost'])

    return if favored.present?

    notification = current_user.active_notifications.new(
      notifiable_id: repost.repostable_id,
      notifiable_type: repost.repostable_type,
      visited_id: repost.repostable.user_id,
      action: 'repost'
    )

    notification.read_at = repost.created_at if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment(current_user, comment)
    commented_ids = Comment.joins(:post).select(:user_id).where(post_id: comment.post_id)
                           .where.not(user_id: current_user.id).distinct
    commented_ids.each do |commented_id|
      save_notification_comment(current_user, comment.id, commented_id['user_id'])
    end

    save_notification_comment(current_user, comment.id, user_id) if commented_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      notifiable_id: comment_id,
      notifiable_type: 'Comment',
      visited_id:,
      action: 'comment'
    )

    notification.read_at = repost.created_at if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_follow(current_user)
    Notification.where(['visitor_id = ? and visited_id = ? and
                        notifiable_type = ? and notifiable_id = ? and action = ?',
                        current_user.id, repost.repostable.user_id, Follow, repost.repostable_id, 'follow'])
  end
end
