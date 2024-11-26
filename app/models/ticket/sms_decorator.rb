Ticket.class_eval do
  def send_sms(message, recipient = nil)
    return false if message.blank?
    
    recipient ||= customer.mobile
    return false if recipient.blank?

    channel = Channel.find_by(area: 'Sms::Gate')
    return false if !channel
    
    channel.deliver(
      recipient: recipient,
      message: message
    )
  end
end

