# frozen_string_literal: true

class CreateUserEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :user_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :attend
      t.boolean :confirmation

      t.timestamps
    end
  end
end
