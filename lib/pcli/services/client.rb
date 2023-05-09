# frozen_string_literal: true

module Pcli
  module Services
    class Client
      include Depends.on('config.endpoint')

      def send(request)
        r = HTTP.send(
          request.method,
          URI.join(endpoint, request.path),
          body: request.params.to_json,
          headers: request.headers
        )
        ApiResponse.new(
          r.code,
          r.status.success?,
          r.status.reason,
          r.to_s
        )
      end
    end
  end
end
