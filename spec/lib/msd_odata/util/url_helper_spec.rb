require 'spec_helper'

describe 'MsdOdata::Util::UrlHelper' do
  describe '.entity_collection_url' do
    before(:each) do
      @entity = MsdOdata::Entity.new('JournalHeaders')
      @base_url = 'github.com'
      @url_helper = MsdOdata::Util::UrlHelper.new(@base_url, @entity)
    end

    it 'builds url for entity collection' do
      # By default 'entity_collection_url' will not build a query. (even if there is)
      @entity.where(@entity[:key].lt(100))
      expected_url = 'github.com/data/JournalHeaders'
      actual_url = @url_helper.entity_collection_url
      expect(actual_url).to eq(expected_url)
    end

    it 'builds collection url with a query' do
      @entity.where(@entity[:Name].eq('khaled')).or(@entity[:age].gt(12)).select('name')

      expected_url = "github.com/data/JournalHeaders?$select=name&$filter=Name eq 'khaled' or age gt 12&"
      actual_url = @url_helper.entity_collection_url(with_query: true)
      expect(actual_url).to eq(expected_url)
    end

    it 'builds collection url with an empty query' do
      entity = MsdOdata::Entity.new('Invoices', {})
      base_url = 'google.com'
      url_helper = MsdOdata::Util::UrlHelper.new(base_url, entity)

      expected_url = "google.com/data/Invoices?"
      actual_url = url_helper.entity_collection_url(with_query: true)
      expect(actual_url).to eq(expected_url)
    end
  end

  describe '.entity_url' do
    it 'builds url for entity' do
      entity = MsdOdata::Entity.new('Customers', { url_params: { 'CustomerId' => 'HS-120' } })
      base_url = 'github.com'
      url_helper = MsdOdata::Util::UrlHelper.new(base_url, entity)

      expected_url = "github.com/data/Customers(CustomerId='HS-120')"

      expect(url_helper.entity_url).to eq(expected_url)
    end
  end

  describe '.build_query' do
    before(:each) do
      @entity = MsdOdata::Entity.new('JournalLines')
      @base_url = 'google.com'
      @url_helper = MsdOdata::Util::UrlHelper.new(@base_url, @entity)
    end

    it 'builds a query with all options' do
      @entity
        .select('Name', 'id')
        .limit(200)
        .skip(20)
        .expand('JournalHeaders')
        .order_by('id')
        .where(@entity[:id].ne('xxxxx'))

      expected_url = "google.com/data/JournalLines?$select=Name,id&$filter=id ne 'xxxxx'&$orderby=id&$top=200&$expand=JournalHeaders&$skip=20&"
      actual_url = @url_helper.entity_collection_url(with_query: true)
      expect(actual_url).to eq(expected_url)
    end
  end
end
