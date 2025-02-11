# frozen_string_literal: true

class RepostsController < ApplicationController
  def create
    @repost = current_user.reposts.build(repost_params)
    @repost.save
    redirect_to request.referer
  end

  def destroy
    @repost = current_user.reposts.find_by(repost_params)
    @repost.delete
    redirect_to request.referer
  end

  private

  def repost_params
    @params = params.permit(:post_id, :repostable_type)
    { repostable_id: @params[:post_id], repostable_type: @params[:repostable_type] }
  end
end
