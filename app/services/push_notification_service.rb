# frozen_string_literal: true

class PushNotificationService < ApplicationService
  FIREBASE_KEY = ENV['FIREBASE_KEY']

  class << self
    def send_notification(title, message, push_notification_tokens, data = nil)
      push_notification_tokens.select! { |token| token.class == String }
      return false if push_notification_tokens.empty?

      options = build_options(title, message, data)
      response = fcm.send(push_notification_tokens, options)
      parse_response(response)
    end

    private

    def fcm
      @fcm ||= FCM.new(FIREBASE_KEY)
    end

    def build_options(title, message, data)
      options = { 'notification':
                    {
                      'title': title,
                      'body': message
                    } }
      options.merge!(data: data) if data
      options
    end

    def parse_response(response)
      if response[:status_code] == 200
        response_body = Oj.load(response[:body])
        { sent: true, success: response_body['success'], failure: response_body['failure'] }
      else
        { sent: false, body: response[:body], response_message: response[:response] }
      end
    end
  end
end
