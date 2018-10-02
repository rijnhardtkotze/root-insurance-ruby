module RootInsurance
  module Api
    module Policyholder
      # Create a policy holder
      #
      # @param [Hash] id Hash containing policyholder's identification number, type and country. See below for details.
      # @param [String] first_name Policyholder's legal first name.
      # @param [String] last_name Policyholder's legal last name.
      # @param [String] email Policyholder's contact email address. (Optional)
      # @param [String] date_of_birth The policyholder's date of birth in the format YYYYMMDD. This field may be omitted if the policyholder's id type is +id+.
      # @param [Hash] cellphone Hash containing policyholder's cellphone number and country. See below for details. (Optional)
      # @param [Hash] app_data A hash containing additional custom data for the policy holder.
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
      #  client.create_policy_holder(
      #    id:         {type: :id, number: "6801015800084", country: "ZA"},
      #    first_name: 'Erlich',
      #    last_name:  'Bachman',
      #    email:      'erlich@avaito.com',
      #    app_data:   {company: 'Aviato'})
      #
      def create_policyholder(id:, first_name:, last_name:, email: nil, date_of_birth: nil, cellphone: nil, app_data: nil)
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

      # List policy holders
      #
      # @param [Hash] id_number An optional ID or passport number to filter by.
      # @param [Array<String, Symbol>, String, Symbol] included_objects An optional list, or single item, of underlying objects to include, e.g. +?include=policies+. Currently, only +policies+ is supported, which will include all policies owned by the policyholder.
      # @return [Array<Hash>]
      #
      # @example
      #   client.list_policyholders(id_number: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e", included_objects: :policies)
      def list_policyholders(id_number: nil, included_objects: nil)
        query = {
          include:   format_included_objects(included_objects),
          id_number: id_number
        }.reject { |_, v| v.nil? }

        get(:policyholders, query)
      end

      # Get a policy holder
      #
      # @param [String] id The unique identifier of the policy holder
      # @param [Array<String, Symbol>, String, Symbol] included_objects An optional list, or single item, of underlying objects to include, e.g. +?include=policies+. Currently, only +policies+ is supported, which will include all policies owned by the policyholder.
      # @return [Hash]
      #
      # @example
      #   client.get_policyholder(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e", included_objects: :policies)
      #
      def get_policyholder(id:, included_objects: nil)
        query = {
          include:   format_included_objects(included_objects),
        }.reject { |_, v| v.nil? }

        get("policyholders/#{id}", query)
      end

      # Update a policy holder
      #
      # @param [String] id The unique identifier of the policy holder
      # @param [String] email Policyholder's contact email address. (Optional)
      # @param [Hash] cellphone Hash containing policyholder's cellphone number and country. See below for details. (Optional)
      # @param [Hash] app_data A hash containing additional custom data for the policy holder.
      # @return [Hash]
      #
      ## == Cellphone
      # [number (string)]   The cellphone number
      # [country (string)]   The ISO Alpha-2 country code of the country of the cellphone number.
      #
      # @example
      #   client.update_policyholders(
      #     id: 'bf1ada91-eecb-4f47-9bfa-1258bb1e0055',
      #     cellphone: {number: '07741011337', country: 'ZA'},
      #     app_data:  {company: 'Pied Piper'})
      #
      def update_policyholder(id:, email: nil, cellphone: nil, app_data: nil)
        data = {
          email:     email,
          cellphone: cellphone,
          app_data:  app_data
        }.reject { |key, value| value.nil? }

        patch("policyholders/#{id}", data)
      end

      # List all the events which are applicable to this policy holder.
      #
      # @param [String] id The unique identifier of the policy holder
      # @return [Array<Hash>]
      #
      # @example
      #  client.list_policyholder_events(id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e")
      #
      def list_policyholder_events(id:)
        get("policyholders/#{id}/events")
      end

      private
      def format_included_objects(included_objects)
        case included_objects
        when String, Symbol
          included_objects
        when Array
          included_objects.join(",")
        end
      end
    end
  end
end