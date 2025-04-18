# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @favorite = current_user.favorites.build(favorite_params)
    @favorite.save
    @favorite.favorable.create_notification_favorite(current_user, @favorite)
    NotificationMailer.favorite_notification(current_user, @favorite.favorable).deliver_now
    redirect_to request.referer
  end

  def destroy
    @favorite = current_user.favorites.find_by(favorite_params)
    @favorite.delete
    redirect_to request.referer
  end

  private

  def favorite_params
    @params = params.permit(:post_id, :favorable_type)
    { favorable_id: @params[:post_id], favorable_type: @params[:favorable_type] }
  end
end
