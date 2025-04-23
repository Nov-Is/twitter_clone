# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }, index: false
      t.references :visited, null: false, foreign_key: { to_table: :users }, index: false
      t.string :action, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.datetime :read_at, optional: true

      t.timestamps
    end
  end
end
