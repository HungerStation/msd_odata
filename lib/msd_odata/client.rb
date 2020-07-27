require 'faraday'
require 'json'

module MsdOdata
  class Client
    include MsdOdata::Util::Logging
    attr_reader :url

    def initialize(url, log_data: true)
      @url = url
      @log_data = log_data
    end

    def request(method, options = {})
      log '----------CLIENT: MSD API REQUEST----------'
      log "METHOD => #{method}"
      if @log_data
        log "RESOURCE => #{url}"
        log "OPTIONS => #{options.except(:headers)}"
      end

      resp = Faraday.send(method, url) do |req|
        req.headers = options[:headers] if options[:headers]
        req.body =  if options[:body]
                      if req.headers["Content-Type"] == "application/json"
                        options[:body].to_json
                      else
                        options[:body]
                      end
                    end
      end
      response = { status: json_format(resp.env.status.to_s), response_body: json_format(resp.env.response.body) }

      log '------CLIENT: MSD API RESPONSE------'
      log "RESPONSE CODE => #{response[:status]}"
      log "RESPONSE BODY => #{response[:response_body]}" if @log_data

      response
    end

    private

    def json_format(response)
      JSON.parse(response)
    rescue JSON::ParserError
      false
    end
  end
end
