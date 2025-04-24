# frozen_string_literal: true

class Comment < ApplicationRecord
  include SharedLogic
  include NotificationConcern

  belongs_to :user
  belongs_to :post
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many_attached :comment_images
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, length: { maximum: 140 }

  def create_comment_notification(current_user)
    create_notification(current_user, post.user, self, 'comment')

    # コメント投稿者への通知
    Comment.where(post_id:).where.not(user_id:).distinct.each do |other_comment|
      create_notification(current_user, other_comment.user, self, 'comment')
    end
  end
end
