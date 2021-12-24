module StructuredApi
  class Endpoint
    extend StructuredApi::StructuredApiable

    def run!
      run_request.response_body
    end

    private

    def run_request
      @run_request ||=
        Typhoeus::Request.new(
          url_and_path,
          {
            method: get_attr(:verb, :get),
            body: get_attr(:body, nil),
            params: get_attr(:params, {}),
            headers: get_attr(:headers, {})
          }
        ).run
    end

    def url_and_path
      my_url = get_attr(:url, '')
      my_url = my_url[0..-2] if my_url[-1] == '/'
      my_path = get_attr(:path, '')
      my_path = my_path[1..-1] if my_path[0] == '/'
      [my_url, my_path].join('/')
    end
  end
end
