# frozen_string_literal: true

class BookmarksController < ApplicationController
  def index
    bookmarkables = current_user.bookmarks.includes(:bookmarkable).order(created_at: :desc).map(&:bookmarkable)
    @bookmark_posts = Kaminari.paginate_array(bookmarkables).page(params[:page])
  end

  def create
    @bookmark = current_user.bookmarks.build(bookmark_params)
    @bookmark.save
    redirect_to request.referer
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by(bookmark_params)
    @bookmark.delete
    redirect_to request.referer
  end

  private

  def bookmark_params
    @params = params.permit(:post_id, :bookmarkable_type, :user_id)
    { bookmarkable_id: @params[:post_id], bookmarkable_type: @params[:bookmarkable_type] }
  end
end
