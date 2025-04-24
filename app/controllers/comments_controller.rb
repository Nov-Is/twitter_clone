# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    @comment.create_comment_notification(current_user)
    NotificationMailer.comment_notification(current_user, @post, @comment).deliver_now
    redirect_to request.referer
  end

  def destroy; end

  private

  def comment_params
    params.require(:comment).permit(:comment, comment_images: [])
  end
end
