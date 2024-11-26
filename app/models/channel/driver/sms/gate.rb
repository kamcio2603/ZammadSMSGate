class Channel::Driver::Sms::Gate < Channel::Driver::Sms::Base

  def self.driver_name
    'SMS Gate'
  end

  def self.driver_instance
    new
  end

  def self.driver_class
    'Sms::Gate'
  end

  def self.description
    'SMS Gate Provider'
  end

  def self.config
    {
      api_key:       { name: 'API Key', type: 'text', required: true },
      api_url:       { name: 'API URL', type: 'text', required: true },
      sender_number: { name: 'Sender Number', type: 'text', required: false },
    }
  end

  def account_data_validation(account)
    errors = []
    errors.push('API Key missing') if account['api_key'].blank?
    errors.push('API URL missing') if account['api_url'].blank?
    errors
  end

  def deliver(options)
    return false if options[:recipient].blank? || options[:message].blank?

    begin
      response = HTTP
        .headers(accept: 'application/json', 'x-api-key': options[:api_key])
        .post("#{options[:api_url]}/send", json: {
          to: sanitize_phone_number(options[:recipient]),
          message: options[:message],
          from: options[:sender_number]
        })

      handle_response(response)
    rescue => e
      Rails.logger.error "SMS Gate error: #{e.message}"
      false
    end
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