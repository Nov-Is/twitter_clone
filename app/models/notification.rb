# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :visited, class_name: 'User'
  belongs_to :visitor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
