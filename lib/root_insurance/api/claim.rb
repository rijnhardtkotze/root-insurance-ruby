require 'mimemagic'

module RootInsurance
  module Api      
    module Claim

      # List all claims
      #
      # @param [String, Symbol] status Either +:open+, +:closed+, +:finalized+, +:acknowledged+ or +:all+. If omitted defaults to +:all+
      # @param [String, Symbol] approval Either +:approved+, +:repudiated+, +:'ex-gratia'+, +:'no-claim'+, +:pending+ or +:all+. If omitted defaults to +:all+
      # @return [Array<Hash>]
      #
      # @example
      #   client.list_claims(status: :open)
      #
      def list_claims(status: nil, approval: nil)
        query = {
          claim_status:    status,
          approval_status: approval
        }.reject { |key, value| value.nil? }

        get(:claims, query)
      end

      # Get a specific claim
      #
      # @param [String] id The claim's id
      # @return [Hash]
      # @example
      #   client.get_claim(id: 'd3d13c48-4dc3-4816-8d01-de3215878225')
      #
      def get_claim(id:)
        get("claims/#{id}")
      end

      # Open a claim
      #
      # @param [String] policy_id The ID of the policy under which the claim is being made. (optional)
      # @param [String] policyholder_id The ID of the policyholder for whom the claim is being made. (optional)
      # @param [String] incident_type A description of the incident type. (optional)
      # @param [String] incident_cause A description of the cause of the incident. (optional)
      # @param [String] incident_date The date on the which the incident occured. (optional)
      # @param [String] app_data An object containing additional custom data for the claim. (optional)
      # @param [String] claimant Object containing claimants's first name, last name, email and/or cellphone. See below for details. (optional)
      # @param [String] requested_amount The requested payout amount (in cents) for the claim. (optional)
      # @return [Hash]
      #
      ## == Claimant
      # [first_name (string)]   The name of the claimant
      # [last_name (string)]   The last name of the claimant
      # [email (string)]   The claimant's email address
      # [cellphone (string)]   The claimant's cellphone number
      #
      # @example
      #   client.open_claim(
      #     policy_id: "8349345c-a6c5-4bf9-8ebb-6bbfc1628715",
      #     incident_type: "Theft",
      #     incident_cause: "Device stolen during burglary",
      #     incident_date: "2017-10-16T10:12:02.872Z",
      #     requested_amount: 13000000,
      #     app_data: {
      #       key1: "value 1"
      #       key2: "value 2"})
      #
      def open_claim(policy_id: nil, policyholder_id: nil, incident_type: nil, incident_cause: nil,
                    incident_date: nil, app_data: nil, claimant: nil, requested_amount: nil)
        data = {
          policy_id:        policy_id,
          policyholder_id:  policyholder_id,
          incident_type:    incident_type,
          incident_cause:   incident_cause,
          incident_date:    incident_date,
          app_data:         app_data,
          claimant:         claimant,
          requested_amount: requested_amount
        }.reject { |key, value| value.nil? }

        post(:claims, data)
      end

      # Update a claim
      #
      # @param [String] claim_id The unique identifier of the claim.
      # @param [String] incident_type A description of the incident type. (optional)
      # @param [String] incident_cause A description of the cause of the incident. (optional)
      # @param [String] incident_date The date on the which the incident occured. (optional)
      # @param [String] app_data An object containing additional custom data for the claim. (optional)
      # @param [String] requested_amount The requested payout amount (in cents) for the claim. (optional)
      # @return [Hash]
      #
      # @example
      #   client.update_claim(
      #     claim_id:         "d3d13c48-4dc3-4816-8d01-de3215878225",
      #     incident_type:    "Theft",
      #     incident_cause:   "Device stolen during burglary",
      #     incident_date:    "2017-10-16T10:12:02.872Z",
      #     app_data:         {key3: "value 3"},
      #     requested_amount: 13000000)
      #
      def update_claim(claim_id:, incident_type: nil, incident_cause: nil, incident_date: nil,
                      app_data: nil, requested_amount: nil)
        data = {
          incident_type:    incident_type,
          incident_cause:   incident_cause,
          incident_date:    incident_date,
          app_data:         app_data,
          requested_amount: requested_amount
        }.reject { |key, value| value.nil? }

        patch("claims/#{claim_id}", data)
      end

      # Link a claim and a policy
      #
      # @param [String] claim_id The unique identifier of the claim.
      # @param [String] policy_id The unique identifier of the policy.
      # @return [Hash]
      #
      # @example
      #  client.link_policy_to_claim(claim_id: "d3d13c48-4dc3-4816-8d01-de3215878225", policy_id: "8349345c-a6c5-4bf9-8ebb-6bbfc1628715")
      #
      def link_policy_to_claim(claim_id:, policy_id:)
        data = {policy_id: policy_id}

        post("claims/#{claim_id}/policy", data)
      end


      # Link a claim and a policy holder
      #
      # @param [String] claim_id The unique identifier of the claim.
      # @param [String] policyholder_id The unique identifier of the policy holder.
      # @return [Hash]
      #
      # @example
      #  client.link_policyholder_to_claim(claim_id: "d3d13c48-4dc3-4816-8d01-de3215878225", policyholder_id: "808f75dc-cb8a-4808-93e9-e13f8eea84de")
      #
      def link_policyholder_to_claim(claim_id:, policyholder_id:)
        data = {policyholder_id: policyholder_id}

        post("claims/#{claim_id}/policyholder", data)
      end

      # List all claim events
      #
      # @param [String] claim_id The unique identifier of the claim.
      # @return [Array<Hash>]
      #
      # @example
      #  client.list_claim_events(claim_id: "d3d13c48-4dc3-4816-8d01-de3215878225")
      #
      def list_claim_events(id: nil, claim_id: nil)
        claim_id = claim_id || id
        get("claims/#{claim_id}/events")
      end

      # Create a claim attachment
      #
      # The file data can be passed using either +path+, +file+, +bytes+ or +base64+.
      #
      # @param [String] claim_id The unique identifier of the claim
      # @param [String] path The full path to the file's location
      # @param [File] file instance of a File object
      # @param [String] bytes The raw butes of the file
      # @param [String] base64 The base64 encoded file
      # @param [String] file_name The file's name (only required when not using +path+ or +file+)
      # @param [String] file_type The file's mime type (only required when using +base64+)
      # @param [String] description A description of the file
      # @return [Hash]
      #
      def create_claim_attachment(claim_id:, path: nil, file: nil, bytes: nil, base64: nil, file_name: nil, file_type: nil, description: '')
        data = if path
          claim_attachment_from_path(path)
        elsif file
          claim_attachment_from_file(file)
        elsif bytes
          raise ArgumentError.new("file_name is required when supplying bytes") unless file_name
          claim_attachment_from_bytes(bytes, file_name, file_type)
        elsif base64
          raise ArgumentError.new("file_name is required when supplying base64") unless file_name
          raise ArgumentError.new("file_type is required when supplying base64") unless file_type
          claim_attachment_from_base46(base64, file_name, file_type)
        else
          {}
        end.merge({description: description})

        post("claims/#{claim_id}/attachments", data)
      end

      private
      def claim_attachment_from_path(path)
        encoded_data = Base64.encode64(File.binread(path))
        file_name = File.basename(path)

        {
          file_base64: encoded_data,
          file_name:   file_name,
          file_type:   MimeMagic.by_magic(File.open(path)).type
        }
      end

      def claim_attachment_from_file(file)
        encoded_data = Base64.encode64(file.read)

        {
          file_base64: encoded_data,
          file_name:   File.basename(file.path),
          file_type:   MimeMagic.by_magic(file).type
        }
      end

      def claim_attachment_from_bytes(bytes, file_name, file_type)
        encoded_data = Base64.encode64(bytes)

        {
          file_base64: encoded_data,
          file_name:   file_name,
          file_type:   file_type || MimeMagic.by_magic(bytes).type
        }
      end

      def claim_attachment_from_base46(base64, file_name, file_type)
        {
          file_base64: base64,
          file_name:   file_name,
          file_type:   file_type
        }
      end

    end
  end
end