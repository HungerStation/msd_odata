module MsdOdata
  class Service
    def initialize(token, base_url, entity)
      @entity = entity
      @url_helper = Util::UrlHelper.new(base_url, entity)
      @options = {
        headers: { 'Authorization': token },
      }
    end

    ##
    # Creates a resource
    # POST request to 'base_url/data/EntityNames'
    #
    # @return [response]
    def create
      @options[:body] = @entity.attrs
      @options[:headers]['Content-Type'] = 'application/json'
      url = @url_helper.entity_collection_url
      request(:post, url)
    end

    ##
    # Queries a resource
    # GET request to 'base_url/data/EntityNames'
    #
    # @return [response]
    def read
      url = @url_helper.entity_collection_url(with_query: true)
      request(:get, url)
    end

    ##
    # Updates a resource
    # PATCH request to 'base_url/data/EntityNames(url_params)'
    #
    # @return [response]
    def update
      @options[:body] = @entity.attrs[:body]
      @options[:headers]['Content-Type'] = 'application/json'
      url = @url_helper.entity_url
      request(:patch, url)
    end

    ##
    # Deletes a resource
    # DELETE request to 'base_url/data/EntityNames(url_params)'
    #
    # @return [response]
    def delete
      url = @url_helper.entity_url
      request(:delete, url)
    end

    ##
    # Finds an entity of a resource
    # GET request to 'base_url/data/EntityNames(url_params)'
    #
    # @return [response]
    def find
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
