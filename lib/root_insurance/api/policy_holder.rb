module RootInsurance::Api
  module PolicyHolder
    def create_policy_holder(id:, first_name:, last_name:, email: nil, date_of_birth: nil, cellphone: nil, app_data: nil)
      raise ArgumentError.new('id needs to be a hash') unless id.is_a? Hash

      data = {
        id:            id,
        first_name:    first_name,
        last_name:     last_name,
        date_of_birth: date_of_birth,
        email:         email,
        cellphone:     cellphone,
        app_data:      app_data
      }.reject { |key, value| value.nil? }

      post(:policyholders, data)
    end

    def list_policy_holders
      get(:policyholders)
    end

    def get_policy_holder(id:)
      get("policyholders/#{id}")
    end

    def update_policy_holder(id:, email: nil, cellphone: nil, app_data: nil)
      data = {
        email:     email,
        cellphone: cellphone,
        app_data:  app_data
      }.reject { |key, value| value.nil? }

      patch("policyholders/#{id}", data)
    end

    def list_policy_holder_events(id:)
      get("policyholders/#{id}/events")
    end
  end
end
