# frozen_string_literal: true

class Post < ApplicationRecord
  include SharedLogic

  belongs_to :user
  has_many_attached :images
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

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
end
