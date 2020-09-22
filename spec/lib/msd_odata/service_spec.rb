require 'spec_helper'

describe 'MsdOdata::Service' do
  describe '.create' do
    before(:each) do
      @token = 'some_token'
      @base_url = 'base_url.com'
    end

    it 'creates a resource' do
      entity = MsdOdata::Entity.new('Customers', { 'Attr' => 'value' })
      service = MsdOdata::Service.new(@token, @base_url, entity)

      expected_options = {
        headers: {
          'Authorization': @token,
          'Content-Type' => 'application/json',
        },
        body: { 'Attr' => 'value' },
      }

      expected_url = 'base_url.com/data/Customers'
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, entity).entity_collection_url

      expect(expected_url).to eq(actual_url)
      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:post, expected_options)

      service.create
    end
  end

  describe '.read' do
    before(:each) do
      @entity = MsdOdata::Entity.new('Customers')
      @token = 'some_token'
      @expected_options = {
        headers: { 'Authorization': @token },
      }
      @base_url = 'base_url.com'
    end

    it 'reads from a resource' do
      service = MsdOdata::Service.new(@token, @base_url, @entity)
      expected_url = 'base_url.com/data/Customers'
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, @entity).entity_collection_url(with_query: true)

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:get, @expected_options)
      expect(expected_url).to eq(actual_url)
      service.read
    end

    it 'reads from a resource with a query' do
      @entity.limit(200).select('ID')
      service = MsdOdata::Service.new('some_token', 'base_url.com', @entity)
      expected_url = 'base_url.com/data/Customers?$select=ID&$top=200&'
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, @entity).entity_collection_url(with_query: true)

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:get, @expected_options)
      expect(expected_url).to eq(actual_url)
      service.read
    end
  end

  describe '.update' do
    before(:each) do
      @token = 'some_token'
      @base_url = 'base_url.com'
    end

    it 'updates a resource' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
        body: { 'Attr' => 'value1' },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new(@token, @base_url, entity)

      expected_options = {
        headers: {
          'Authorization': 'some_token',
          'Content-Type' => 'application/json',
        },
        body: { 'Attr' => 'value1' },
      }

      expected_url = "base_url.com/data/Customers(CustomerAccount='12')"
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, entity).entity_url

      expect(expected_url).to eq(actual_url)
      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:patch, expected_options)

      service.update
    end
  end

  describe '.delete' do
    before(:each) do
      @token = 'some_token'
      @base_url = 'base_url.com'
      @expected_options = {
        headers: { 'Authorization': @token },
      }
    end

    it 'deletes a resource' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new(@token, @base_url, entity)

      expected_url = "base_url.com/data/Customers(CustomerAccount='12')"
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, entity).entity_url

      expect(expected_url).to eq(actual_url)
      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:delete, @expected_options)

      service.delete
    end
  end

  describe '.find' do
    before(:each) do
      @token = 'some_token'
      @base_url = 'base_url.com'
      @expected_options = {
        headers: { 'Authorization': @token },
      }
    end

    it 'finds an entity' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new(@token, @base_url, entity)

      expected_url = "base_url.com/data/Customers(CustomerAccount='12')"
      actual_url = MsdOdata::Util::UrlHelper.new(@base_url, entity).entity_url

      expect(expected_url).to eq(actual_url)
      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:get, @expected_options)

      service.find
    end
  end
end
