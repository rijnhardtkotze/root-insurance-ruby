module RootInsurance
  module Api
    module Payment

      # Create a payment method
      #
      # @param [String] policyholder_id The unique identifier of the policy holder.
      # @param [String] type The payment method type. Curently only +'debit_order'+ is supported. If omitted, defaults to +'debit_order'+ (optional)
      # @param [Hash] bank_details Bank details to use for the debit order. See below for details.
      # @param [String] policy_ids The date on the which the incident occured. (optional)
      # @return [Hash]
      #
      ## == Bank details
      # [account_holder (string)]   Name of account holder.
      # [bank (string)]   Bank name - one of [+absa+, +capitec+, +fnb+, +investec+, +nedbank+, +postbank+, +standard_bank+]
      # [branch_code (string)]   Branch code for bank account
      # [account_number (string)]   Bank account number
      #
      # @example
      #  bank_details = {
      #    first_name:     "Erlich",
      #    last_name:      "Bachman",
      #    bank:           "absa",
      #    branch_code:    "12345",
      #    account_number: "123456789"
      #  }
      #  client.create_payment_method(
      #          policyholder_id: "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e",
      #          bank_details:    bank_details)
      #
      def create_payment_method(policyholder_id:, type: 'debit_order', bank_details: {}, policy_ids: nil)
        validate_bank_details(bank_details)

        data = {
          type:         type,
          bank_details: bank_details
        }

        if policy_ids && policy_ids.is_a?(Array)
          data.merge!(policy_ids: policy_ids)
        elsif policy_ids && policy_ids.is_a?(String)
          data.merge!(policy_ids: [policy_ids])
        end

        post("policyholders/#{policyholder_id}/payment-methods", data)
      end

      # Link a payment method to a policy
      #
      # @param [String] policy_id The unique identifier of the policy.
      # @param [String] payment_method_id The unique identifier of the payment method.
      #
      # @example
      #   client.link_payment_method(
      #     policy_id:         "128ba0c0-3f6a-4f8b-9b40-e2066b02b59e",
      #     payment_method_id: "e0b7b222-772f-47ac-b08d-c7ba38aa1b25")
      #
      def link_payment_method(policy_id:, payment_method_id:)
        data = {payment_method_id: payment_method_id}

        put("policies/#{policy_id}/payment-method", data)
      end

      private
      def validate_bank_details(bank_details)
        [:first_name, :last_name, :bank, :branch_code, :account_number].each do |key|
          if !(bank_details[key] || bank_details[key.to_sym])
          raise ArgumentError.new("Bank details need to include #{key}")
          end
        end
      end
    end
  end
end