# frozen_string_literal: true

module SharedLogic
  extend ActiveSupport::Concern

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def reposted_by?(user)
    reposts.exists?(user_id: user.id)
  end

  def favorite_count
    favorites.count
  end

  def repost_count
    reposts.count
  end
end
