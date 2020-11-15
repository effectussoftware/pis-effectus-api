# frozen_string_literal: true

namespace :push_notifications do
  desc 'sends a push notification to all users when a recurrent communication starts to appear in the feed'
  task send_to_recurrent_communications: :environment do
    communications = Communication.recurrent_from_date_hour Time.zone.now
    communications.each(&:create_recurrent_dummy)
  end

  desc 'sends a push notification to all users that have not yet replied 2 days before the event starts'
  task send_48_hour_reminder: :environment do
    events = Event.where(cancelled: false).on_day(2.days.from_now)
    events.each do |event|
      event.invitations.not_confirmed.each(&:send_48_hour_reminder)
    end
  end
end
