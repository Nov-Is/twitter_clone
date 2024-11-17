# frozen_string_literal: true

class AddProfileColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.string :username
      t.text :self_introduction
      t.string :location
      t.string :website
    end
  end
end
