# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @recommend_posts = Post.all.order(created_at: :desc).page(params[:tab1])
    @follow_posts = Post.where(user_id: current_user.followees.pluck(:id)).order(created_at: :desc).page(params[:tab2])
  end

  def show; end

  def new; end
end
