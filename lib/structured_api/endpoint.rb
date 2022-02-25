module StructuredApi
  class Endpoint
    extend StructuredApi::StructuredApiable
    class InvalidRequest < StandardError; end

    def debug!(val = true)
      @debug = val
      self
    end

    def run!
      run_request.response_body
    end

    private

    def run_request
      puts typhoeus_params.inspect if @debug
      @run_request ||=
        Typhoeus::Request.new(*typhoeus_params).run
    end

    def url_and_path
      my_url = get_method_or_attr(:url, nil)
      raise InvalidRequest, 'At least a url is needed' unless my_url

      my_url = my_url[0..-2] if my_url[-1] == '/'
      my_path = get_method_or_attr(:path, '')
      my_path = my_path[1..-1] if my_path[0] == '/'
      [my_url, my_path].join('/')
    end

    def typhoeus_params
      [
        url_and_path,
        {
          method: get_method_or_attr(:verb, :get),
          body: get_method_or_attr(:body, nil),
          params: get_method_or_attr(:params, {}),
          headers: get_method_or_attr(:headers, {}),
          followlocation: true
        }
      ]
    end
  end
end
