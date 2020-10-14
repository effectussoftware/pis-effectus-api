# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :attend
      t.boolean :confirmation, default: false
      t.timestamp :changed_last_seen

      t.timestamps
    end
  end
end
