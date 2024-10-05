# frozen_string_literal: true

module PostsHelper
  def post_page(tab)
    page = {
      'tab1' => 'tab1',
      'tab2' => 'tab2'
    }
    page[tab]
  end
end
