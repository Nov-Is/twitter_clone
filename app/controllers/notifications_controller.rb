# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.recent.page(params[:page]).per(20)
    @notifications.unread.update_all(read_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
  end
end
