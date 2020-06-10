require 'faraday'
require 'json'

module MsdOdata
  class Client
    include MsdOdata::Util::Logging
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def request(method, options = {})
      log '----------CLIENT: MSD API REQUEST----------'
      log "METHOD => #{method}"
      log "RESOURCE => #{url}"
      log "OPTIONS => #{options}"

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
      response = { status: json_format(resp.env.status.to_s), response_body: json_format(resp.env.response_body) }

      log '------CLIENT: MSD API RESPONSE------'
      log "RESPONSE CODE => #{response[:status]}"
      log "RESPONSE BODY => #{response[:response_body]}"

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
