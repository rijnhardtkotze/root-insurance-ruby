require 'root/insurance/client/quote'
require 'root/insurance/client/policy_holder'
require 'root/insurance/client/application'
require 'root/insurance/client/policy'

module Root::Insurance
  class Client
    include Root::Insurance::Client::Quote
    include Root::Insurance::Client::PolicyHolder
    include Root::Insurance::Client::Application
    include Root::Insurance::Client::Policy

    def initialize(app_id, app_secret, env=nil)
      @app_id = app_id
      @app_secret = app_secret
      @env = env || :sandbox
    end

    private
    def client
      @client ||= Root::Client.new(@app_id, @app_secret, @env)
    end

    def post(entity, data)
      cleaned_data = data.reject { |key, value| value.nil? }

      client.post("insurance/#{entity}", cleaned_data)
    end

    def get(entity)
      client.get("insurance/#{entity}")
    end

    def put(entity, data)
      cleaned_data = data.reject { |key, value| value.nil? }

      client.put("insurance/#{entity}", cleaned_data)
    end

    def patch(entity, data)
      cleaned_data = data.reject { |key, value| value.nil? }

      client.patch("insurance/#{entity}", cleaned_data)
    end

  end
end
