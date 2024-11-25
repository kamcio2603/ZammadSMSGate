module Channel
  class Driver
    class Sms::Gate
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
    end
  end
end