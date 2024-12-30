# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @followee_count = @user.followees_count
    @follower_count = @user.followers_count
    @my_posts = @user.posts.all.order(created_at: :desc).page(params[:my_posts])
    @favorite_posts = @user.favorites.all.order(created_at: :desc).page(params[:favorite_posts])
    @reposts = @user.reposts.all.all.order(created_at: :desc).page(params[:reposts])
    @comments = @user.comments.all.all.order(created_at: :desc).page(params[:comments])
  end

  def edit
    @user = User.find(params[:id])
    check_current_user(@user)
  end

  def update
    @user = User.find(params[:id])
    check_current_user(@user)
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to users_profile_path(current_user.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:header_image, :icon_image, :name, :username, :self_introduction, :location, :website,
                                 :birth_date)
  end

  # ログインユーザーか確認
  def check_current_user(user)
    return if user == current_user

    redirect_to users_profile_path
  end
end
