# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(favorable_id: params[:post_id], favorable_type: params[:favorable_type])
    @favorite.user = current_user
    @favorite.save
    redirect_to request.referer
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user, favorable_id: params[:post_id],
                                 favorable_type: params[:favorable_type])
    @favorite.delete
    redirect_to request.referer
  end
end
