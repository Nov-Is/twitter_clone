# frozen_string_literal: true

class AddPolymorphicToRepost < ActiveRecord::Migration[7.0]
  def change
    add_reference :reposts, :repostable, polymorphic: true
  end
end
