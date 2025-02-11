# frozen_string_literal: true

class RemovePostFromReoposts < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reposts, :post, null: false, foreign_key: true
  end
end
