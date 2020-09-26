# frozen_string_literal: true

class AddPushNotificationTokensToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :push_notification_tokens, :string, array: true, default: []
  end
end
