# frozen_string_literal: true

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## User Info
      t.string :name
      t.string :picture
      t.string :email
      t.boolean :is_admin, default: false
      t.boolean :is_active, default: true

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, [:uid, :provider],     unique: true
    # add_index :users, :unlock_token,       unique: true
  end
end
