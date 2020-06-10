require 'spec_helper'

describe 'MsdOdata::UrlHelper' do
  describe '.entity_collection_url' do
    it 'builds url for entity collection' do
      entity = MsdOdata::Entity.new('Customers', {})
      base_url = 'github.com'
      url_helper = MsdOdata::UrlHelper.new(base_url, entity)

      expected_url = 'github.com/data/Customers'

      expect(url_helper.entity_collection_url).to eq(expected_url)
    end
  end

  describe '.entity_url' do
    it 'builds url for entity' do
      entity = MsdOdata::Entity.new('Customers', { url_params: { 'CustomerId' => 'HS-120' } })
      base_url = 'github.com'
      url_helper = MsdOdata::UrlHelper.new(base_url, entity)

      expected_url = "github.com/data/Customers(CustomerId='HS-120')"

      expect(url_helper.entity_url).to eq(expected_url)
    end
  end
end
