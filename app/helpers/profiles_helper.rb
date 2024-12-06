# frozen_string_literal: true

module ProfilesHelper
  def post_page(tab)
    page = {
      'tab1' => 'my_posts',
      'tab2' => 'reposts',
      'tab3' => 'comments',
      'tab4' => 'favorite_posts'
    }
    page[tab]
  end
end
