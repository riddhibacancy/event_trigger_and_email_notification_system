# spec/services/iterable_api_service_spec.rb

require 'rails_helper'
require 'webmock'

RSpec.describe IterableService, type: :service do
  
  describe '.send_event_to_iterable' do
    # Define necessary test data
    let(:user) { create(:user) }
    let(:event_name) { "Test Event" }
    let(:event_detail) { { event_name: event_name, user_email: user.email } }

    it "sends event data to Iterable" do
      # Expectation: HTTParty should be called with the correct arguments
      expect(HTTParty).to receive(:post).with(ITERABLE_EMAIL_LINKIterableService::ITERABLE_EVENTS,
        body: event_detail.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      # Invoke the method under test
      IterableService.send_event(event_name, user)
    end
  end

  describe '.send_email_notification' do
    # Define necessary test data
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:email_data) do
      {
        campaignId: event.id,
        recipientEmail: user.email,
        recipientUserId: user.id,
        dataFields: { event_name: event.title },
        allowRepeatMarketingSends: true,
        metadata: {}
      }
    end

    it "sends email notification using Iterable" do
      # Stub the request to Iterable's email target endpoint
      WebMock.stub_request(:post, IterableService::ITERABLE_EMAIL_LINK)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: { msg: "Email Sent", code: "Success", params: email_data }.to_json, headers: {})

      # Expectation: HTTParty should be called with the correct arguments
      expect(HTTParty).to receive(:post).with(
        IterableService::ITERABLE_EMAIL_LINK,
        body: email_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      # Invoke the method under test
      IterableService.send_email(user, event)
    end
  end
end
