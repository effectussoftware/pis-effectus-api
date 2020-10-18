# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PushNotificationService, type: :service do
  let(:successes) { 3 }

  let(:failures) { 1 }

  let(:fcm_good_response) { { body: { 'success' => successes, 'failure' => failures }.to_json, status_code: 200 } }

  let(:body) { 'the body' }

  let(:response_message) { 'the response' }

  let(:fcm_bad_response) { { body: body, response: response_message, status_code: 'Not 200' } }

  let(:title) { 'title' }

  let(:message) { 'message' }

  describe '#send_notification' do
    context 'correct args' do
      before(:each) do
        allow_any_instance_of(FCM).to receive(:send).and_return(fcm_good_response)
        @push_notification_tokens = []
        3.times { |_| @push_notification_tokens << Faker::Internet.password }
        @options = { 'notification':
                     {
                       'title': title,
                       'body': message
                     } }
      end

      context 'without data' do
        it 'returns sent: true and number of successes and failures' do
          expect_any_instance_of(FCM).to receive(:send).with(@push_notification_tokens, @options)
          expect(PushNotificationService.send_notification(title, message, @push_notification_tokens))
            .to eq(sent: true, success: successes, failure: failures)
        end
      end

      context 'with data' do
        it 'returns sent: true and number of successes and failures' do
          data = { some: 'data' }
          @options.merge! data: data
          expect_any_instance_of(FCM).to receive(:send).with(@push_notification_tokens, @options)
          expect(PushNotificationService.send_notification(title, message, @push_notification_tokens, data))
            .to eq(sent: true, success: successes, failure: failures)
        end
      end
    end

    context 'incorrect args' do
      it "returns false and doesn't call FCM if no push_notification_token is given" do
        expect(FCM).to_not receive(:new)
        expect_any_instance_of(FCM).to_not receive(:send)
        expect(PushNotificationService.send_notification(title, message, [])).to eq(false)
      end

      it "returns false and doesn't call FCM if no push_notification_token is a string" do
        expect(FCM).to_not receive(:new)
        expect_any_instance_of(FCM).to_not receive(:send)
        expect(PushNotificationService.send_notification(title, message, [484, create(:user)])).to eq(false)
      end

      it "ignores push_notification_tokens that aren't string" do
        good_push_notification_token = 'jfie347'
        push_notification_tokens = [good_push_notification_token, create(:user)]
        options = { 'notification':
                    {
                      'title': title,
                      'body': message
                    } }
        allow_any_instance_of(FCM).to receive(:send).and_return(fcm_good_response)
        expect_any_instance_of(FCM).to receive(:send).with([good_push_notification_token], options)
        PushNotificationService.send_notification(title, message, push_notification_tokens)
      end

      it 'returns body and response from FCM response if request status different from 200' do
        push_notification_tokens = %w[474fjd jfuj387]
        allow_any_instance_of(FCM).to receive(:send).and_return(fcm_bad_response)
        expect(PushNotificationService.send_notification(title, message, push_notification_tokens))
          .to eq(sent: false, body: body, response_message: response_message)
      end
    end
  end
end
