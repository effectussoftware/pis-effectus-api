# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :address
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :cost, default: 0
      t.timestamp :updated_event_at
      t.boolean :cancelled, default: false

      t.timestamps
    end
  end
end
