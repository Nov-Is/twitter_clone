# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    all_posts
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = current_user.comments.new
  end

  def new; end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.content.present? || @post.images[0].present?
      post_save(@post)
    else
      all_posts
      flash.now[:alert] = 'ポストできませんでした。'
      render :index, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
  end

  def all_posts
    @recommend_posts = Post.all.order(created_at: :desc).page(params[:recommend])
    @follow_posts = Post.where(user_id: current_user.followees.pluck(:id)).order(created_at: :desc)\
                        .page(params[:follow])
  end

  def post_save(post)
    if post.save
      flash[:success] = 'ポストを送信しました。'
      redirect_to root_path
    else
      all_posts
      render :index, status: :unprocessable_entity
    end
  end
end
