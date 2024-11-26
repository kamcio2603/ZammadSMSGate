class Channel::Driver::Sms::Gate < Channel::Driver::Sms::Base

  def self.driver_name
    'SMS Gate'
  end

  def self.driver_config
    {
      api_key:       { value: nil },
      api_url:       { value: nil },
      sender_number: { value: nil },
    }
  end

  def send(message, recipient)
    return false if !recipient
    return false if !config[:api_key]
    return false if !config[:api_url]

    begin
      response = HTTP
        .headers(accept: 'application/json', 'x-api-key': config[:api_key])
        .post(config[:api_url] + '/send', json: {
          to: recipient.gsub(/[^\d+]/, ''),
          message: message,
          from: config[:sender_number]
        })

      if response.status.success?
        Rails.logger.info "SMS sent successfully: #{JSON.parse(response.body.to_s)['message_id']}"
        true
      else
        Rails.logger.error "SMS sending failed: #{JSON.parse(response.body.to_s)['error']}"
        false
      end
    rescue => e
      Rails.logger.error "SMS Gate error: #{e.message}"
      false
    end
  end
end 