Rails.application.config.to_prepare do
  next if !ActiveRecord::Base.connection.active?

  Ticket::Article::Type.create_if_not_exists(
    name: 'sms',
    communication: true,
    updated_by_id: 1,
    created_by_id: 1
  )

  Channel.register_adapter(:sms_gate, 'Channel::Driver::Sms::Gate')
end

