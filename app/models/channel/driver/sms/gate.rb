class Channel::Driver::Sms::Gate
  NAME = 'sms_gate'

  def self.definition
    {
      name: 'SMS Gate',
      adapter: 'sms_gate',
      account: [
        { name: 'api_key', display: 'API Key', tag: 'input', type: 'text', limit: 100, null: false },
        { name: 'api_url', display: 'API URL', tag: 'input', type: 'text', limit: 100, null: false },
        { name: 'sender_number', display: 'Sender Number', tag: 'input', type: 'text', limit: 20, null: true }
      ],
      notification: [
        { name: 'options::notification::sender', display: 'Sender', tag: 'input', type: 'text', limit: 20, null: true },
        { name: 'options::notification::recipient', display: 'Recipient', tag: 'input', type: 'text', limit: 20, null: false },
      ],
    }
  end

  def self.available?(_channel)
    true
  end

  def self.notification?
    true
  end

  def self.send(options, attr, notification = false)
    return false if !options[:recipient]

    response = HTTP
      .headers(accept: 'application/json', 'x-api-key': options[:api_key])
      .post(options[:api_url] + '/send', json: {
        to: options[:recipient].to_s.gsub(/[^\d+]/, ''),
        message: NotificationFactory::Renderer.new(
          objects: { ticket: options[:ticket] },
          locale: 'pl-pl'
        ).render(attr),
        from: options[:sender] || options[:sender_number]
      })

    if response.status.success?
      Rails.logger.info "SMS sent successfully: #{JSON.parse(response.body.to_s)['message_id']}"
      true
    else
      Rails.logger.error "SMS sending failed: #{JSON.parse(response.body.to_s)['error']}"
      false
    end
  rescue StandardError => e
    Rails.logger.error "SMS Gate error: #{e.message}"
    false
  end
end 