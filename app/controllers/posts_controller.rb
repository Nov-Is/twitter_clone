# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @recommend_posts = Post.all.order(created_at: :desc).page(params[:recommend])
    @follow_posts = Post.where(user_id: current_user.followees.pluck(:id)).order(created_at: :desc)\
                        .page(params[:follow])
  end

  def show; end

  def new; end
end
