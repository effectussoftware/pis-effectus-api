class AddPublishedToEventsAndNotificationSentToInvitations < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :published, :boolean, default: false
    add_column :invitations, :notification_sent, :boolean, default: false
  end
end
