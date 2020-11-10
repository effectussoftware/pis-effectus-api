# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :reviews
  has_many :invitations
  has_many :events, through: :invitations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable
  include DeviseTokenAuth::Concerns::User
  alias devise_create_token create_token

  before_save :destroy_sessions, unless: :is_active?

  scope :active, -> { where(is_active: true) }

  def create_token(client: nil, lifespan: nil, cost: nil, **token_extras)
    push_notification_token = tokens[client].try(:[], 'push_notification_token')
    token = devise_create_token(**{ client: client, lifespan: lifespan, cost: cost }.merge(token_extras))
    tokens[token.client].merge!(push_notification_token: push_notification_token)
    token
  end

  class << self
    def send_notification(title, message, data = nil, specific_tokens = nil)
      send_notification_with_tokens(title, message, specific_tokens || push_notification_tokens, data)
    end

    private

    def push_notification_tokens
      push_notification_tokens = []

      pluck(:tokens).each do |user_tokens|
        user_tokens.each do |_, token|
          push_notification_tokens << token['push_notification_token']
        end
      end
      push_notification_tokens
    end

    def send_notification_with_tokens(title, message, push_notification_tokens, data)
      PushNotificationService.send_notification(title, message, push_notification_tokens, data)
    end
  end

  def send_notification(title, message, data = nil)
    self.class.send_notification(title, message, data, push_notification_tokens)
  end

  def push_notification_tokens
    push_notification_tokens = []
    tokens.each do |_, token|
      push_notification_tokens << token['push_notification_token'] if token['push_notification_token']
    end
    push_notification_tokens
  end

  def destroy_sessions
    self.tokens = {}
  end
end
