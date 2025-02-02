# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorable, polymorphic: true

  def favorite_count(post)
    Favorite.where(favorable_id: post.id, favorable_type: post.model_name.name).count
  end
end
