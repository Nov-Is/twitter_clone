# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    flash[:success] = "#{@user.name}さんをフォローしました。"
    redirect_to request.referer
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    flash[:success] = "#{@user.name}さんをフォロー解除しました。"
    redirect_to request.referer
  end
end
