module MsdOdata
  class UrlHelper
    def initialize(base_url, entity)
      @base_url = base_url
      @entity = entity
    end

    def entity_collection_url
      "#{@base_url}/data/#{@entity.name}"
    end

    def entity_url
      raise "'url_params' are missing." unless @entity.attrs[:url_params].is_a? Hash
      params = @entity.attrs[:url_params].map { |k,v| "#{k}='#{v}'"}.join(',')
      "#{entity_collection_url}(#{params})"
    end
  end
end
