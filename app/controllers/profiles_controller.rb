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

  def edit; end

  def update; end
end
