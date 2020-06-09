module MsdOdata
  class UrlHelper
    def initialize(base_url, entity)
      @base_url = base_url
      @entity = entity
    end

    def entity_collection_url
      "#{@base_url}/data/#{@entity.name}?#{@entity.query}"
    end

    def entity_url
      raise "'query_params' are missing." unless @entity.attrs[:query_params].is_a? Hash
      params = @entity.attrs[:query_params].map { |k,v| "#{k}='#{v}'"}.join(',')
      "#{entity_collection_url}(#{params})?#{@entity.query}"
    end
  end
end
