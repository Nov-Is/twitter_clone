# frozen_string_literal: true

module NotificationConcern
  extend ActiveSupport::Concern

  def create_notification(visitor, visited, notifiable, action)
    existing_notification = Notification.where(
      visitor_id: visitor.id,
      visited_id: visited.id,
      notifiable_type: notifiable.class.name,
      notifiable_id: notifiable.id,
      action:
    )

    return if existing_notification.present?

    notification = visitor.active_notifications.new(
      visited_id: visited.id,
      notifiable_id: notifiable.id,
      notifiable_type: notifiable.class.name,
      action:
    )

    notification.read_at = Time.zone.now if visitor.id == visited.id
    notification.save if notification.valid?
  end
end
