# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :address
      t.datetime :date
      t.timestamp :start_time
      t.integer :cost
      t.timestamp :duration

      t.timestamps
    end
  end
end
