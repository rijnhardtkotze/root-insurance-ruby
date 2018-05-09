require 'base64'

describe RootInsurance::Api::Claim do
  let(:base_url) { "https://sandbox.root.co.za/v1/insurance" }
  let(:url) { "#{base_url}/claims" }

  let(:app_id)      { 'app_id' }
  let(:app_secret)  { 'app_secret' }
  let(:environment) { :sandbox }

  let(:client) { RootInsurance::Client.new(app_id, app_secret, environment) }

  let(:claim_id) { "d3d13c48-4dc3-4816-8d01-de321587822" }

  describe :list_claims do
    context "without any query params" do
      it "gets from the correct url" do
        stub_request(:get, url)
          .to_return(body: "{}")

        client.list_claims
      end
    end

    context "with a query specified" do
      it "passes the given status" do
        stub_request(:get, url)
          .with(query: {claim_status: :open})
          .to_return(body: "{}")

        client.list_claims(status: :open)
      end

      it "passes the given approval" do
        stub_request(:get, url)
          .with(query: {approval_status: :approved})
          .to_return(body: "{}")

        client.list_claims(approval: :approved)
      end

      it "passes the given approval and status" do
        stub_request(:get, url)
          .with(query: {approval_status: :approved, claim_status: :open})
          .to_return(body: "{}")

        client.list_claims(approval: :approved, status: :open)
      end
    end
  end

  describe :get_claim do
    it "gets from the correct url" do
      claim_url = "#{url}/#{claim_id}"
      stub_request(:get, claim_url)
        .to_return(body: "{}")

      client.get_claim(id: claim_id)
    end
  end

  describe :open_claim do
    context "without any arguments" do
      it "posts to the correct url" do
        stub_request(:post, url)
          .with(body: {}.to_json)
          .to_return(body: "{}")

        client.open_claim
      end
    end

    context "given a policy id" do
      let(:policy_id) { "8349345c-a6c5-4bf9-8ebb-6bbfc1628715" }
      it "posts the correct data" do
        stub_request(:post, url)
          .with(body: {policy_id: policy_id})
          .to_return(body: "{}")

        client.open_claim(policy_id: policy_id)
      end
    end

    context "given a policy holder id" do
      let(:policy_holder_id) { "8349345c-a6c5-4bf9-8ebb-6bbfc1628715" }
      it "posts the correct data" do
        stub_request(:post, url)
          .with(body: {policy_holder_id: policy_holder_id})
          .to_return(body: "{}")

        client.open_claim(policy_holder_id: policy_holder_id)
      end
    end
  end

  describe :link_policy_to_claim do
    let(:policy_id) { "8349345c-a6c5-4bf9-8ebb-6bbfc1628715" }

    let(:link_url) { "#{url}/#{claim_id}/policy" }

    it "posts the correct data to the correct url" do
      stub_request(:post, link_url)
        .with(body: {policy_id: policy_id})
        .to_return(body: "{}")

      client.link_policy_to_claim(
        claim_id:  claim_id,
        policy_id: policy_id)
    end
  end

  describe :link_policholdery_to_claim do
    let(:policyholder_id) { "8349345c-a6c5-4bf9-8ebb-6bbfc1628715" }

    let(:link_url) { "#{url}/#{claim_id}/policyholder" }

    it "posts the correct data to the correct url" do
      stub_request(:post, link_url)
        .with(body: {policyholder_id: policyholder_id})
        .to_return(body: "{}")

      client.link_policyholder_to_claim(
        claim_id:        claim_id,
        policyholder_id: policyholder_id)
    end
  end

  describe :list_claim_events do
    let(:get_url) { "#{url}/#{claim_id}/events" }
    it "gets from the correct url" do
      stub_request(:get, get_url)
        .to_return(body: "{}")

      client.list_claim_events(id: claim_id)
    end
  end

  describe :create_claim_attachment do
    let(:path) { 'spec/support/unicorn.png' }
    let(:encoded) { Base64.encode64(File.binread(path)) }
    let(:description) { "A unicorn" }
    let(:post_url) { "#{url}/#{claim_id}/attachments" }

    it "posts to the correct url" do
      stub_request(:post, post_url)
        .to_return(body: "{}")

      client.create_claim_attachment(claim_id: claim_id)
    end

    context "given a file path" do
      it "encodes the file data" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_base64: encoded))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, path: path)
      end

      it "includes the file name" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_name: "unicorn.png"))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, path: path)
      end

      it "includes the file type" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_type: "image/png"))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, path: path)
      end

      it "includes the description" do
        stub_request(:post, post_url)
          .with(body: hash_including(description: description))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, path: path, description: description)
      end
    end

    context "given a file object" do
      let(:file) { File.open(path) }

      it "encodes the file data" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_base64: encoded))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, file: file)
      end

      it "includes the file name" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_name: "unicorn.png"))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, file: file)
      end

      it "includes the file type" do
        stub_request(:post, post_url)
          .with(body: hash_including(file_type: "image/png"))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, file: file)
      end

      it "includes the description" do
        stub_request(:post, post_url)
          .with(body: hash_including(description: description))
          .to_return(body: "{}")

        client.create_claim_attachment(claim_id: claim_id, file: file, description: description)
      end
    end

    context "given the raw bytes" do
      it "encodes the file data" do

      end
    end

    context "given a byte64 encoded string" do
      it "does not encode the file data" do

      end
    end

  end
end
