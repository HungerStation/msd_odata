module MsdOdata
  class Service
    def initialize(token, base_url, entity)
      @entity = entity
      @url_helper = UrlHelper.new(base_url, entity)
      @options = {
        headers: { 'Authorization': token },
      }
    end

    def create
      @options[:body] = @entity.attrs[:body]
      url = @url_helper.entity_collection_url
      request(:post, url)
    end

    def read
      url = @url_helper.entity_collection_url
      request(:get, url)
    end

    def update
      @options[:body] = @entity.attrs[:body]
      url = @url_helper.entity_url
      request(:patch, url)
    end

    def delete
      @options[:body] = @entity.attrs[:body]
      url = @url_helper.entity_url
      request(:delete, url)
    end

    def find_entity
      url = @url_helper.entity_url
      request(:get, url)
    end

    private

    def request(method, url)
      client = Client.new(url)
      client.request(method, @options)
    end
  end
end
