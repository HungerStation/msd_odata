module MsdOdata
  module Util
    class UrlHelper
      def initialize(base_url, entity)
        @base_url = base_url
        @entity = entity
      end

      def entity_collection_url(with_query: false)
        url = "#{@base_url}/data/#{@entity.name}"

        return url unless with_query
        url + build_query
      end

      def entity_url
        raise "'url_params' are missing." unless @entity.attrs[:url_params].is_a?(Hash)

        "#{entity_collection_url}(#{build_url_params})"
      end

      private

      # Builds a query string from the query_hash in 'entity' instance
      def build_query
        query = '?'
        query_hash = @entity.query
        query += "$select=#{query_hash[:select]}&" unless query_hash[:select].nil?
        query += "$filter=#{query_hash[:filters]}&" unless query_hash[:filters].nil?
        query += "$orderby=#{query_hash[:order_by]}&" unless query_hash[:order_by].nil?
        query += "$top=#{query_hash[:top]}&" unless query_hash[:top].nil?
        query += "$expand=#{query_hash[:expand]}&" unless query_hash[:expand].nil?
        query += "$skip=#{query_hash[:skip]}&" unless query_hash[:skip].nil?
        query
      end

      # Parses 'url_params' hash to look like: "key='value',key='value'"
      def build_url_params
        @entity.attrs[:url_params].map { |k, v| "#{k}='#{v}'" }.join(',')
      end
    end
  end
end
