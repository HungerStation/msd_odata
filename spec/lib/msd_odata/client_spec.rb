require 'spec_helper'

describe 'MsdOdata::Client' do
  describe 'External request' do
    it 'queries available requests from MSD' do
      stub_http_request(:get, "https://hs-devdevaos.sandbox.ax.dynamics.com/data/").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'hs-devdevaos.sandbox.ax.dynamics.com',
          'User-Agent'=>'Ruby'
          }).
      to_return(status: 401)
      uri = URI('https://hs-devdevaos.sandbox.ax.dynamics.com/data/')

      response = Net::HTTP.get(uri)
      expect(response).to be_an_instance_of(String)
    end
  end
end
