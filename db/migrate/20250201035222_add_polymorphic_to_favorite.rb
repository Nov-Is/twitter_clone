# frozen_string_literal: true

class AddPolymorphicToFavorite < ActiveRecord::Migration[7.0]
  def change
    add_reference :favorites, :favorable, polymorphic: true
  end
end
