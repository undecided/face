module Face
  class Endpoint
    extend Face::Faceable

    def run!
      run_request.response_body
    end

    private

    def run_request
      @run_request ||=
        Typhoeus::Request.new(
          get_attr(:url),
          {
            method: get_attr(:verb, :get),
            body: get_attr(:body, nil),
            params: get_attr(:params, {}),
            headers: get_attr(:headers, {})
          }
        ).run
    end
  end
end
