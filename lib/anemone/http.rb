require 'net/http'

module Anemone
  class HTTP < Net::HTTP
    # Maximum number of redirects to follow on each get_response
    REDIRECTION_LIMIT = 5

    #
    # Retrieve an HTTP response for *url*, following redirects.
    # Returns the response object, response code, and final URI location.
    # 
    def self.get(url)
      handle_response(url, get_response(url))
    end

    def self.post(url, data)
      handle_response(url, get_response(url, data))
    end

    #
    # Get an HTTPResponse for *url*, sending the appropriate User-Agent string
    #
    def self.get_response(url, postdata = nil)
      full_path = url.query.nil? ? url.path : "#{url.path}?#{url.query}"
      Net::HTTP.start(url.host, url.port) do |http|
        if postdata.nil?
          return http.get(full_path, {'User-Agent' => Anemone::USER_AGENT })
        else
          return http.post(full_path, postdata, {'User-Agent' => Anemone::USER_AGENT })
        end
      end
    end

    private

    def self.handle_response(url, response)
      code = Integer(response.code)
      loc = url

      limit = REDIRECTION_LIMIT
      while response.is_a?(Net::HTTPRedirection) and limit > 0
          loc = URI(response['location'])
          loc = url.merge(loc) if loc.relative?
          response = get_response(loc)
          limit -= 1
      end

      return response, code, loc
    end
  end
end