require 'zammad/application'

class Zammad::Application::SmsGate < Zammad::Application
  def self.info
    {
      name: 'SMS Gate',
      version: '0.1.0',
      description: 'Integration with SMS Gate for sending SMS directly from tickets',
      url: 'https://github.com/yourusername/zammad_sms_gate',
      author: 'Your Name',
      author_url: 'https://yourdomain.com',
      license: 'MIT',
    }
  end

  def self.install
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

  def self.uninstall
    Setting.find_by(name: 'sms_gate_api_key')&.destroy
  end
end

