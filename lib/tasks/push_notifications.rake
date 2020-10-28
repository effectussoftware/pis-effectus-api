namespace :push_notifications do
  desc "sends a push notification to all users when a recurrent communication starts to appear in the feed"
  task send_to_recurrent_communications: :environment do
    communications = Communication.recurrent_from_date_hour Time.zone.now
    communications.each do |communication|
      communication.create_recurrent_dummy
    end
  end

end
