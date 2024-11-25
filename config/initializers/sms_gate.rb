Rails.application.config.after_initialize do
  Setting.create_if_not_exists(
    title: 'SMS Gate API Key',
    name: 'sms_gate_api_key',
    area: 'Integration::SmsGate',
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

Rails.application.reloader.to_prepare do
  Ticket::Article::Type.create_if_not_exists(
    name: 'sms',
    communication: true,
    updated_by_id: 1,
    created_by_id: 1
  )

  Channel.register_addable(
    name: 'SMS Gate',
    provider: 'sms_gate'
  )
end

