# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable
  include DeviseTokenAuth::Concerns::User

  class << self
    def send_notification(title, message)
      send_notification_with_tokens(title, message, pluck[push_notification_tokens].flatten)
    end

    private

    def send_notification_with_tokens(title, message, push_notification_tokens)
      PushNotificationService.send_notification(title, message, push_notification_tokens)
    end
  end

  def send_notification(title, message)
    self.class.send_notification_with_tokens(title, message, push_notification_tokens)
  end
end
