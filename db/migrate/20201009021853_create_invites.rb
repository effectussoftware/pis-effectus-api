# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :attend
      t.boolean :confirmation

      t.timestamps
    end
  end
end
