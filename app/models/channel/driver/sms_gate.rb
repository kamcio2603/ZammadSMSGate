module Channel
  module Driver
    class SmsGate
      NAME = 'sms_gate'.freeze

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

      def send(options, attr, notification = false)
        Rails.logger.debug "Sending SMS via SMS Gate: #{options.inspect}"

        return false if !options[:recipient]

        sms_gate = SmsGate.new(
          options[:api_key],
          options[:api_url]
        )

        message = NotificationFactory::Renderer.new(
          objects: { ticket: options[:ticket] },
          locale: 'pl-pl'
        ).render(attr)

        sms_gate.send_sms(
          to: options[:recipient],
          message: message,
          from: options[:sender] || options[:sender_number]
        )
      end
    end
  end
end