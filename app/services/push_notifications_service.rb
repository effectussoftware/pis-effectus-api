# frozen_string_literal: true

class PushNotificationService < ApplicationService
  FIREBASE_KEY = ENV['FIREBASE_KEY']

  class << self
    def fcm
      @fcm ||= FCM.new(FIREBASE_KEY)
    end

    def send_notification(title, message, push_notification_tokens, data: nil)
      options = { 'notification':
                    {
                      'title': title,
                      'body': message
                    } }
      options['nofitications']['data'] = data if data
      fcm.send(push_notification_tokens, options)
    end
  end
end
