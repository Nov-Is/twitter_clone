# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    flash[:success] = "#{@user.name}さんをフォローしました。"
    relationship = Relationship.find_by(follower_id: current_user.id, followed_id: @user.id)
    relationship.create_follow_notification(current_user)
    NotificationMailer.follow_notification(current_user, @user).deliver_now
    redirect_to request.referer
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    flash[:success] = "#{@user.name}さんをフォロー解除しました。"
    redirect_to request.referer
  end
end
