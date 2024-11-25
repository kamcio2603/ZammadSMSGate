class Channel::Driver::Sms
  def send(options)
    return if options[:recipient].blank?
    return if options[:message].blank?

    # Get configured options
    options = Setting.get('sms_gate_config')
    return if options.blank?

    api = ZammadSmsGate::API.new(options[:api_key])
    api.send_sms(options[:recipient], options[:message])
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

