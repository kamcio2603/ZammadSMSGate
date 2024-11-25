import axios from 'axios';

const API_BASE_URL = 'https://sms-gate.app/api';

export const smsGateService = {
  async sendSMS(to: string, message: string) {
    try {
      const response = await axios.post(`${API_BASE_URL}/send-sms`, { to, message });
      return response.data;
    } catch (error) {
      console.error('Error sending SMS:', error);
      throw error;
    }
  },

  async getReceivedMessages() {
    try {
      const response = await axios.get(`${API_BASE_URL}/received-messages`);
      return response.data;
    } catch (error) {
      console.error('Error fetching received messages:', error);
      throw error;
    }
  }
};

