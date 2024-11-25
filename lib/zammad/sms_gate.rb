require 'http'
require 'json'

class SmsGate
  def initialize(api_key, api_url = 'https://api.smsgate.example.com')
    @api_key = api_key
    @api_url = api_url
  end

  def send_sms(to:, message:, from: nil)
    response = HTTP
      .headers(accept: 'application/json', 'x-api-key': @api_key)
      .post(@api_url + '/send', json: {
        to: sanitize_phone_number(to),
        message: message,
        from: from
      })

    handle_response(response)
  rescue StandardError => e
    Rails.logger.error "SMS Gate error: #{e.message}"
    false
  end

  private

  def handle_response(response)
    result = JSON.parse(response.body.to_s)
    
    if response.status.success?
      Rails.logger.info "SMS sent successfully: #{result['message_id']}"
      true
    else
      Rails.logger.error "SMS sending failed: #{result['error']}"
      false
    end
  end

  def sanitize_phone_number(number)
    number.to_s.gsub(/[^\d+]/, '')
  end
end 