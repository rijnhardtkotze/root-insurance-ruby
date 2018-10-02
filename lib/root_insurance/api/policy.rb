module RootInsurance
  module Api      
    module Policy

      # Issue a policy
      #
      # @param [String] application_id The unique identifier of the application.
      # @param [Hash, nil] app_data An object containing additional custom data for the policy.
      # @return [Hash]
      #
      # @example
      #   client.issue_policy(
      #     application_id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e",
      #     app_data:       {gadget_colour: "Space Grey"})
      #
      def issue_policy(application_id:, app_data: nil)
        data = {
          application_id: application_id,
        }

        data.merge!(app_data: app_data) if app_data

        post(:policies, data)
      end

      # Add a benificiary to a policy
      #
      # @param [String] policy_id The unique identifier of the policy.
      # @param [String] first_name The beneficiary's first name
      # @param [String] last_name The beneficiary's last name
      # @param [Hash] id An hash containing the beneficiary's identification number, type and country. See below.
      # @param [Integer] percentage An integer representing the percentage of a claim payout that the beneficiary should receive.
      # @param [String] cellphone Hash containing beneficiary's cellphone number and country. See below for details. (optional)
      # @return [Hash]
      #
      ## == ID
      # [type (string or symbol)]   Either +:id+ or +:passport+
      # [number (string)]   The id or passport number
      # [country (string)]   The ISO Alpha-2 country code of the country of the id/passport number.
      #
      ## == Cellphone
      # [number (string)]   The cellphone number
      # [country (string)]   The ISO Alpha-2 country code of the country of the cellphone number.
      #
      # @example
      #   client.add_policy_beneficiary(
      #     policy_id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e",
      #     first_name: "Jared"
      #     last_name:  "Dunn",
      #     id:         {type: :id, number: "8704094800082", country: "ZA"},
      #     percentage: 100)
      #
      def add_policy_beneficiary(policy_id:, id:, first_name:, last_name:, percentage:, cellphone: nil)
        raise ArgumentError.new('id needs to be a hash') unless id.is_a? Hash

        data = {
          id:         id,
          first_name: first_name,
          last_name:  last_name,
          percentage: percentage,
          cellphone:  cellphone
        }.reject { |k, v| v.nil? }

        put("policies/#{policy_id}/beneficiaries", data)
      end

      # List policies
      #
      # @param [String] id_number The National ID Number of the policyholder (optional)
      # @return [Array<Hash>]
      #
      # @example
      #   client.list_policies(id_number: "8704094800082")
      #
      def list_policies(id_number: nil)
        query = id_number ? {id_number: id_number} : nil

        get(:policies, query)
      end

      # Get a policy
      #
      # @param [String] id The unique identifier of the policy
      # @return [Hash]
      #
      # @example
      #   client.get_policy(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e")
      #
      def get_policy(id:)
        get("policies/#{id}")
      end

      # Cancel a policy
      #
      # @param [String] id The unique identifier of the policy
      # @param [String] reason A reason for why this policy is being cancelled.
      # @return [Hash]
      #
      # @example
      #  client.cancel_policy(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e", reason: "Not needed anymore")
      #
      def cancel_policy(id:, reason:)
        data = {reason: reason}

        post("policies/#{id}/cancel", data)
      end

      # Update a policy.
      # Currently, only updating the app_data object is supported
      #
      # @param [String] id The unique identifier of the policy
      # @param [Hash] app_data An object containing additional custom data for the policy.
      # @return [Hash]
      #
      # @example
      #  app_data = {gadget_color: "Space Grey", has_screen_cover: true}
      #  client.update_policy(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e", app_data: app_data)
      #
      def update_policy(id:, app_data:)
        data = {app_data: app_data}

        patch("policies/#{id}", data)
      end

      # Update a policy's billing amount.
      #
      # @param [String] id The unique identifier of the policy
      # @param [Integer] billing_amount The billing amount to be set on the policy in cents.
      # @return [Hash]
      #
      # @example
      #  client.update_policy_billing_amount(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e", billing_amount: 45000)
      #
      def update_policy_billing_amount(id:, billing_amount:)
        data = {billing_amount: billing_amount}

        post("policies/#{id}/billing_amount", data)
      end

      # List a policy's bebeficiaries
      #
      # @param [String] id The unique identifier of the policy
      # @return [Array<Hash>]
      #
      # @example
      #  client.list_policy_beneficiaries(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e")
      #
      def list_policy_beneficiaries(id:)
        get("policies/#{id}/beneficiaries")
      end

      # List all the events which are applicable to this policy.
      #
      # @param [String] id The unique identifier of the policy
      # @return [Array<Hash>]
      #
      # @example
      #  client.list_policy_events(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e")
      #
      def list_policy_events(id:)
        get("policies/#{id}/events")
      end
    end
  end
end