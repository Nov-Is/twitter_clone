# frozen_string_literal: true

class Repost < ApplicationRecord
  include NotificationConcern

  belongs_to :user
  belongs_to :repostable, polymorphic: true

  def create_repost_notification(current_user)
    create_notification(current_user, repostable.user, repostable, 'repost')
  end
end
