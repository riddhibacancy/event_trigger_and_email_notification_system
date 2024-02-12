require 'webmock'

class IterableService
  include WebMock::API
  WebMock.enable!

  ITERABLE_EVENTS = "https://api.iterable.com/api/events/track"
  ITERABLE_EMAIL_LINK = "https://api.iterable.com/api/email/target"

  def self.send_event(event_name, user)
    event_data = { event_name: event_name, user_email: user.email }

    # Stub the request to Iterable's events track endpoint
    WebMock.stub_request(:post, ITERABLE_EVENTS).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: event_data.to_json, headers: {})

    # Send the event data to Iterable using HTTParty
    HTTParty.post(ITERABLE_EVENTS, body: event_data.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # Method to send email notification using Iterable
  def self.send_email(user, event)

    email_data = {
      campaignId: event.id,
      recipientEmail: user.email,
      recipientUserId: user.id,
      dataFields: { event_name: event.title },
      allowRepeatMarketingSends: true,
      metadata: {}
    }

    WebMock.stub_request(:post, ITERABLE_EMAIL_LINK).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: { msg: "Email Sent", code: "Success", params: email_data }.to_json, headers: {})

    # Send the email notification to Iterable using HTTParty
    HTTParty.post(ITERABLE_EMAIL_LINK, body: email_data.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
