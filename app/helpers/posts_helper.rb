# frozen_string_literal: true

module PostsHelper
  def post_page(tab)
    page = {
      'tab1' => 'recommend',
      'tab2' => 'follow'
    }
    page[tab]
  end

  def favorite_button_for(post, user)
    if post.favorited_by?(user)
      link_to post_favorites_path(post, favorable_type: post.model_name.name),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :delete } do
        tag.i('', class: 'fa-solid fa-heart text-danger')
      end
    else
      link_to post_favorites_path(post, favorable_type: post.model_name.name),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :post } do
        tag.i('', class: 'fa-regular text-heart')
      end
    end
  end

  def repost_button_for(post, user)
    if post.reposted_by?(user)
      link_to post_reposts_path(post, repostable_type: post.model_name.name),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :delete } do
        tag.i('', class: 'fa-solid fa-repeat text-success')
      end
    else
      link_to post_reposts_path(post, repostable_type: post.model_name.name),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :post } do
        tag.i('', class: 'fa-solid fa-repeat')
      end
    end
  end

  def bookmark_button_for(post, user)
    if post.bookmark_by?(user)
      link_to user_bookmark_path(user.id, bookmarkable_type: post.model_name.name, post_id: post.id),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :delete } do
        tag.i('', class: 'fa-solid fa-bookmark text-primary')
      end
    else
      link_to user_bookmarks_path(user, bookmarkable_type: post.model_name.name, post_id: post.id),
              class: 'btn text-light btn-custom ms-5 me-1 position-relative',
              data: { "turbo-method": :post } do
        tag.i('', class: 'fa-regular fa-bookmark')
      end
    end
  end

  def message_button_for(user, current_user)
    return if user.id == current_user.id

    room = Room.joins(:entries)
               .where(entries: { user_id: [current_user.id, user.id] })
               .group(:room_id)
               .having('COUNT(DISTINCT user_id) = 2')
               .pick(:room_id)

    if room
      link_to 'メッセージを再開', room_path(room)
    else
      link_to 'メッセージを送る', rooms_path(user_id: user.id), data: { "turbo-method": :post }
    end
  end
end
