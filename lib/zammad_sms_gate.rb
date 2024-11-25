require 'httparty'

module ZammadSmsGate
  class API
    include HTTParty
    base_uri 'https://sms-gate.app/api'

    def initialize
      @options = { 
        headers: { 
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{Setting.get('sms_gate_api_key')}"
        }
      }
    end

    def send_sms(to, message)
      self.class.post('/send', @options.merge(body: { to: to, message: message }.to_json))
    end

    def receive_sms
      self.class.get('/receive', @options)
    end
  end

  class Ticket
    def self.send_sms(ticket_id, message)
      ticket = ::Ticket.find(ticket_id)
      customer = ticket.customer
      
      if customer.phone.blank?
        Rails.logger.error "Cannot send SMS: No phone number for customer of ticket ##{ticket_id}"
        return false
      end

      response = API.new.send_sms(customer.phone, message)
      
      if response.success?
        ::Ticket::Article.create(
          ticket_id: ticket_id,
          body: "SMS sent: #{message}",
          type: ::Ticket::Article::Type.lookup(name: 'note'),
          sender: ::Ticket::Article::Sender.lookup(name: 'System'),
          internal: true
        )
        true
      else
        Rails.logger.error "Failed to send SMS for ticket ##{ticket_id}: #{response.body}"
        false
      end
    end
  end
end

# Zammad hooks
Zammad::Application.config.after_initialize do
  Setting.create_if_not_exists(
    title: 'SMS Gate API Key',
    name: 'sms_gate_api_key',
    area: 'Integration::SMSGate',
    description: 'API key for SMS Gate integration',
    options: {
      form: [
        {
          display: 'API Key',
          null: false,
          name: 'sms_gate_api_key',
          tag: 'input',
        },
      ],
    },
    state: '',
    preferences: {
      permission: ['admin.integration'],
    },
    frontend: false
  )
end

