# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to request.referer
  end

  def destroy; end

  private

  def comment_params
    params.require(:comment).permit(:comment, comment_images: [])
  end
end
