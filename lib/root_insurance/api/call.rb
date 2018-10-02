module RootInsurance
  module Api
    module Call
      # List all the logged calls
      #
      # @return [Hash]
      #
      # @example
      #   client.list_calls
      def list_calls
        get(:calls)
      end

      # Get a specific call
      #
      # @param [String] id The unique identifier of the call
      # @return [Hash]
      #
      # @example
      #   client.get_call(id: 'd3d13c48-4dc3-4816-8d01-de3215878225')
      def get_call(id:)
        get("calls/#{id}")
      end

      # List a call's events
      #
      # @param [String] id The unique identifier of the call
      # @return [Hash]
      #
      # @example
      #   client.list_call_events(id: 'd3d13c48-4dc3-4816-8d01-de3215878225')
      def list_call_events(id:)
        get("calls/#{id}/events")
      end
    end
  end
end