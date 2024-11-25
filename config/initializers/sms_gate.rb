Zammad::Application.config.after_initialize do
  return if !Setting.exists?(state: 'running')
  return if !ActiveRecord::Base.connection.active?

  Ticket::Article::Type.create_if_not_exists(
    name: 'sms',
    communication: true,
    updated_by_id: 1,
    created_by_id: 1
  )

  Channel.register_addable(
    name: 'SMS Gate',
    provider: 'sms'
  )
end

