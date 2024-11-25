Ticket.class_eval do
  def send_sms(message)
    ZammadSmsGate::Ticket.send_sms(id, message)
  end
end

