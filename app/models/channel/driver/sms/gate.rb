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

  def self.required_fields
    [:api_key, :api_url]
  end

  def account_data_validation(account)
    return if !account
    return if !account['api_key']
    return if !account['api_url']
    account
  end

  def send(options)
    return false if !options[:recipient]
    return false if !options[:message]

    begin
      response = HTTP
        .headers(accept: 'application/json', 'x-api-key': options[:api_key])
        .post(options[:api_url] + '/send', json: {
          to: options[:recipient].gsub(/[^\d+]/, ''),
          message: options[:message],
          from: options[:sender_number]
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