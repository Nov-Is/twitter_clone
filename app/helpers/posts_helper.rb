# frozen_string_literal: true

module PostsHelper
  def post_page(tab)
    page = {
      'tab1' => 'recommend',
      'tab2' => 'follow'
    }
    page[tab]
  end
end
