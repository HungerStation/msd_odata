require 'spec_helper'

describe 'MsdOdata::Service' do
  describe '.create' do
    it 'creates a resource' do
      entity = MsdOdata::Entity.new('Customers', { 'Attr' => 'value' })
      service = MsdOdata::Service.new('some_token', 'base_url.com', entity)

      expected_options = {
        headers: {
          'Authorization': 'some_token',
          'Content-Type' => 'application/json',
        },
        body: { 'Attr' => 'value' },
      }

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:post, expected_options)

      service.create
    end
  end

  describe '.read' do
    it 'reads from a resource' do
      entity = MsdOdata::Entity.new('Customers')
      service = MsdOdata::Service.new('some_token', 'base_url.com', entity)

      expected_options = {
        headers: { 'Authorization': 'some_token' },
      }

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:get, expected_options)

      service.read
    end
  end

  describe '.update' do
    it 'updates a resource' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
        body: { 'Attr' => 'value1' },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new('some_token', 'base_url.com', entity)

      expected_options = {
        headers: {
          'Authorization': 'some_token',
          'Content-Type' => 'application/json',
        },
        body: { 'Attr' => 'value1' },
      }

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:patch, expected_options)

      service.update
    end
  end

  describe '.delete' do
    it 'deletes a resource' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new('some_token', 'base_url.com', entity)

      expected_options = {
        headers: { 'Authorization': 'some_token' },
      }

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:delete, expected_options)

      service.delete
    end
  end

  describe '.find' do
    it 'finds an entity' do
      attrs = {
        url_params: { 'CustomerAccount' => 12 },
      }
      entity = MsdOdata::Entity.new('Customers', attrs)
      service = MsdOdata::Service.new('some_token', 'base_url.com', entity)

      expected_options = {
        headers: { 'Authorization': 'some_token' },
      }

      expect_any_instance_of(MsdOdata::Client).to receive(:request).with(:get, expected_options)

      service.find
    end
  end
end
