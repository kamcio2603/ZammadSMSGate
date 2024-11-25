import React, { useState, useEffect } from 'react';
import axios from 'axios';

interface SMS {
  id: string;
  from: string;
  to: string;
  message: string;
  timestamp: string;
}

const ZammadSMSGate: React.FC = () => {
  const [messages, setMessages] = useState<SMS[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [recipientNumber, setRecipientNumber] = useState('');

  useEffect(() => {
    // Fetch received messages periodically
    const fetchMessages = async () => {
      try {
        const response = await axios.get('https://sms-gate.app/api/received-messages');
        setMessages(response.data);
      } catch (error) {
        console.error('Error fetching messages:', error);
      }
    };

    fetchMessages();
    const interval = setInterval(fetchMessages, 60000); // Fetch every minute

    return () => clearInterval(interval);
  }, []);

  const sendSMS = async () => {
    try {
      await axios.post('https://sms-gate.app/api/send-sms', {
        to: recipientNumber,
        message: newMessage
      });
      setNewMessage('');
      setRecipientNumber('');
      alert('SMS sent successfully!');
    } catch (error) {
      console.error('Error sending SMS:', error);
      alert('Failed to send SMS');
    }
  };

  return (
    <div>
      <h2>SMS Gateway Integration</h2>
      <div>
        <h3>Send SMS</h3>
        <input
          type="text"
          value={recipientNumber}
          onChange={(e) => setRecipientNumber(e.target.value)}
          placeholder="Recipient Number"
        />
        <textarea
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
          placeholder="Message"
        />
        <button onClick={sendSMS}>Send SMS</button>
      </div>
      <div>
        <h3>Received Messages</h3>
        <ul>
          {messages.map((sms) => (
            <li key={sms.id}>
              From: {sms.from}, Message: {sms.message}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default ZammadSMSGate;

