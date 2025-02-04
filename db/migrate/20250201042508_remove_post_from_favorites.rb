# frozen_string_literal: true

class RemovePostFromFavorites < ActiveRecord::Migration[7.0]
  def change
    remove_reference :favorites, :post, null: false, foreign_key: true
  end
end
