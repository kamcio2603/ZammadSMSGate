module SmsGate
  class << self
    def config
      @config ||= {}
    end

    def configure
      yield(config)
    end
  end

  class Api
    def initialize(config)
      @api_key = config[:api_key]
      @api_url = 'https://sms-gate.app/api'
    end

    def send_sms(to, message)
      params = {
        to: to,
        message: message,
        api_key: @api_key
      }

      response = HTTP.post("#{@api_url}/send", json: params)
      JSON.parse(response.body.to_s)
    end

    def receive_sms
      response = HTTP.get("#{@api_url}/receive", params: { api_key: @api_key })
      JSON.parse(response.body.to_s)
    end
  end
end

Zammad::Application.routes.draw do
  post '/api/v1/sms_gate/send', to: 'sms_gate#send_sms'
  get '/api/v1/sms_gate/receive', to: 'sms_gate#receive_sms'
end

class SmsGateController < ApplicationController
  def send_sms
    sms_gate = SmsGate::Api.new(api_key: Setting.get('sms_gate_api_key'))
    result = sms_gate.send_sms(params[:to], params[:message])
    render json: result
  end

  def receive_sms
    sms_gate = SmsGate::Api.new(api_key: Setting.get('sms_gate_api_key'))
    messages = sms_gate.receive_sms
    render json: messages
  end
end
