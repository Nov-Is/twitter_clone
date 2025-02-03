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
end
