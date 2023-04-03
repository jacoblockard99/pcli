require 'http'
require_relative 'api_request'
require_relative 'api_response'

module Pcli
  class Api
    include Depends.on('config.endpoint')
    attr_accessor :token

    def send(request)
      r = HTTP.send(
        request.method,
        URI::join(endpoint, request.path),
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

    def info
      send ApiRequest.new('info')
    end

    def auth(username, password, totp)
      send ApiRequest.new('admin/auth')
        .method(:post)
        .params(
          username: username,
          password: password,
          totp: totp
        )
    end

    private

    def authenticated(request)
      request.header('Authentication', "Bearer #{token}")
    end
  end
end
