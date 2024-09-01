# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :phone_number, null: false
      t.date :birth_date, null: false
    end
  end
end
