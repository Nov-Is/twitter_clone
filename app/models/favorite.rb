# frozen_string_literal: true

class Favorite < ApplicationRecord
  include NotificationConcern

  belongs_to :user
  belongs_to :favorable, polymorphic: true

  def create_favorite_notification(current_user)
    create_notification(current_user, favorable.user, favorable, 'favorite')
  end
end
