# frozen_string_literal: true

class Relationship < ApplicationRecord
  include NotificationConcern

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  has_many :notifications, as: :notifiable, dependent: :destroy

  def create_follow_notification(current_user)
    create_notification(current_user, followed, self, 'follow')
  end
end
