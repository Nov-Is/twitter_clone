# frozen_string_literal: true

class RenameFolloweeidToFollowedidInRelationships < ActiveRecord::Migration[7.0]
  def change
    remove_index :relationships, column: :followee_id
    rename_column :relationships, :followee_id, :followed_id
    add_index :relationships, :followed_id, name: 'index_relationships_on_followed_id'
  end
end
