require 'httparty'

require 'root_insurance/api/quote'
require 'root_insurance/api/policy_holder'
require 'root_insurance/api/application'
require 'root_insurance/api/policy'
require 'root_insurance/api/claim'

class RootInsurance::Client
  include RootInsurance::Api::Quote
  include RootInsurance::Api::PolicyHolder
  include RootInsurance::Api::Application
  include RootInsurance::Api::Policy
  include RootInsurance::Api::Claim

  def initialize(app_id, app_secret, env=nil)
    @app_id = app_id
    @app_secret = app_secret
    @env = env || :sandbox
  end

  private
  def get(entity, query=nil)
    response = HTTParty.get("#{api_root}/#{entity}",
      query: query || {},
      basic_auth: auth)

    parse_response(response)
  end

  def post(entity, data)
    response = HTTParty.post("#{api_root}/#{entity}",
      body:       data.to_json,
      basic_auth: auth,
      headers:    {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    parse_response(response)
  end

  def put(entity, data)
    response = HTTParty.put("#{api_root}/#{entity}",
      body:       data.to_json,
      basic_auth: auth,
      headers:    {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    parse_response(response)
  end

  def patch(entity, data)
    response = HTTParty.patch("#{api_root}/#{entity}",
      body:       data.to_json,
      basic_auth: auth,
      headers:    {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    parse_response(response)
  end

  def parse_response(response)
    parsed = JSON.parse(response.body)

    case response.code
    when 200
      parsed
    when 400
      raise RootInsurance::InputError.new(error_message(parsed))
    when 401, 403
      raise RootInsurance::AuthenticationError.new(error_message(parsed))
    else
      raise error_message(parsed)
    end
  end

  def auth
    {username: @app_id, password: @app_secret}
  end

  def api_root
    @env == :production ? "https://api.root.co.za/v1/insurance" : "https://sandbox.root.co.za/v1/insurance"
  end

  def error_message(response_body)
    response_body["error"] || response_body["message"]
  end

end