class Channel::Driver::SmsGate
  def send(options)
    Rails.logger.info "Sending SMS via SMS Gate: #{options.inspect}"
    
    recipient = options[:recipient]
    message = options[:message]
    
    sms_gate = ::SmsGate::Api.new(api_key: Setting.get('sms_gate_api_key'))
    
    result = sms_gate.send_sms(recipient, message)
    
    Rails.logger.info "SMS Gate API response: #{result.inspect}"
    
    if result['success'] == true
      true
    else
      raise "Failed to send SMS: #{result['message']}"
    end
  end
  
  def self.definition
    {
      name: 'sms_gate',
      adapter: 'sms_gate',
      account: [
        { name: 'api_key', display: 'API Key', tag: 'input', type: 'text', limit: 100, null: false },
      ],
    }
  end
end