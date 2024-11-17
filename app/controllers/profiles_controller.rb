# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @followee_count = @user.followees_count
    @follower_count = @user.followers_count
    @my_posts = @user.posts.all.order(created_at: :desc).page(params[:myposts])
    # binding.pry
  end

  def edit; end

  def update; end
end
