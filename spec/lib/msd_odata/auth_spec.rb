require 'spec_helper'

describe 'MsdOdata::Auth' do
  describe '.token' do
    it 'creates a token' do
      tenant_id = '11111111-1Aa1-1a11-1a1a-1a1111a11111'
      options = { 'key': 'value' }
      url = "https://login.microsoftonline.com/#{tenant_id}/oauth2/token"
      stub_http_request(:post, url).
      with(
        body: {"key"=>"value"},
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'User-Agent'=>'Faraday v1.0.1'
        }).
      to_return(status: 200, body: 'false', headers: {})
      auth = MsdOdata::Auth.new(tenant_id, options)
      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:post, { body: options })
      auth.token
    end
  end
end
