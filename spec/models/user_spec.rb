# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  PUSH_NOTIFICATION_RESPONSE = 'Push notification response'

  let(:title) { 'title' }

  let(:message) { 'message' }

  describe 'before_saves' do
    describe 'destroy_sessions' do
      it 'destroys user sessions if account is deactivated' do
        user = create(:user, is_active: true)
        user.create_new_auth_token
        expect(user.tokens).to_not eq({})
        user.update(is_active: false)
        expect(user.reload.tokens).to eq({})
      end

      it "can't create a new session if user is deactivated" do
        user = create(:user, is_active: false)
        user.create_new_auth_token
        expect(user.reload.tokens).to eq({})
      end
    end
  end

  describe '#send_notification' do
    before(:each) do
      allow(PushNotificationService).to receive(:send_notification).and_return(PUSH_NOTIFICATION_RESPONSE)
    end

    context 'without users' do
      it 'calls Push Notification with an empty array for push_notification_tokens' do
        expect(PushNotificationService).to receive(:send_notification).with(title, message, [], nil)
        expect(User.send_notification(title, message)).to eq(PUSH_NOTIFICATION_RESPONSE)
      end
    end

    context 'with users' do
      context 'no user with push_notification_tokens' do
        it 'calls Push Notification with an empty array for push_notification_tokens' do
          create_list(:user, 3)

          expect(PushNotificationService).to receive(:send_notification).with(title, message, [], nil)
          expect(User.send_notification(title, message)).to eq(PUSH_NOTIFICATION_RESPONSE)
        end
      end

      context 'some users have push_notification_tokens' do
        before(:each) do
          create_list(:user, 3)

          @push_notification_tokens = []
          3.times { |_| @push_notification_tokens << Faker::Internet.password }

          @first_user = User.first
          @second_user = User.second

          3.times { |_| @first_user.create_new_auth_token }

          @first_user.tokens[@first_user.tokens.keys.first][:push_notification_token] = @push_notification_tokens[0]
          @first_user.tokens[@first_user.tokens.keys.second][:push_notification_token] = @push_notification_tokens[1]
          @first_user.save

          @second_user.create_new_auth_token
          @second_user.tokens[@second_user.tokens.keys.first][:push_notification_token] = @push_notification_tokens[2]
          @second_user.save
        end

        it 'calls Push Notification with an empty array for push_notification_tokens' do
          expect(PushNotificationService)
            .to receive(:send_notification).with(title,
                                                 message,
                                                 array_including(*@push_notification_tokens),
                                                 nil)
          expect(User.send_notification(title, message)).to eq(PUSH_NOTIFICATION_RESPONSE)
        end

        context 'with a scope' do
          it 'only sends to users within the scope' do
            users = User.where('id NOT IN (?)', @second_user.id)
            @push_notification_tokens -= @second_user.push_notification_tokens
            expect(PushNotificationService)
              .to receive(:send_notification).with(title,
                                                   message,
                                                   array_including(*@push_notification_tokens),
                                                   nil)
            expect(users.send_notification(title, message)).to eq(PUSH_NOTIFICATION_RESPONSE)
          end
        end
      end
    end
  end

  describe '.send_notification' do
    before(:each) do
      allow(PushNotificationService).to receive(:send_notification).and_return(PUSH_NOTIFICATION_RESPONSE)
    end

    context 'without push_notification_tokens' do
      it 'calls PushNotificationService without any push_notification_tokens' do
        user = create(:user)
        expect(PushNotificationService).to receive(:send_notification).with(title,
                                                                            message,
                                                                            array_including(*@push_notification_tokens),
                                                                            nil)
        expect(user.send_notification(title, message)).to eq(PUSH_NOTIFICATION_RESPONSE)
      end
    end

    context 'with push_notification_tokens' do
      it "sends the message with the requested data and the user's push_notification_tokens" do
        user = create(:user)
        user.create_new_auth_token
        push_notification_token = Faker::Internet.password
        user.tokens[user.tokens.keys.first][:push_notification_token] = push_notification_token
        user.save
        data = { some_data: 'really' }

        expect(PushNotificationService).to receive(:send_notification).with(title,
                                                                            message,
                                                                            array_including(push_notification_token),
                                                                            data)
        expect(user.send_notification(title, message, data)).to eq(PUSH_NOTIFICATION_RESPONSE)
      end
    end
  end

  describe '.push_notification_tokens' do
    context 'without tokens' do
      it 'returns empty array' do
        user = create(:user)
        expect(user.push_notification_tokens).to eq([])
      end
    end

    context 'with tokens' do
      it 'returns the user push_notification_tokens' do
        user = create(:user)
        3.times { |_| user.create_new_auth_token }
        push_notification_tokens = []
        user.tokens.each do |_, value|
          push_notification_tokens << Faker::Internet.password
          value.merge! push_notification_token: push_notification_tokens[-1]
        end
        user.create_new_auth_token
        user.save
        expect(user.push_notification_tokens).to contain_exactly(*push_notification_tokens)
      end
    end
  end
end
