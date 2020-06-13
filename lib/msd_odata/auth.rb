module MsdOdata
  class Auth
    attr_reader :url, :options

    def initialize(tenant_id, options = {}, base_url = "https://login.microsoftonline.com")
      @url = "#{base_url}/#{tenant_id}/oauth2/token"
      @options = { body: options }
    end

    def token
      status, response = Client.new(url).request(:post, options)
      "#{response['token_type']} #{response['access_token']}" if status == 200
    end
  end
end
