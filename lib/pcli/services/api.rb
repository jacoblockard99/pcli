# frozen_string_literal: true

module Pcli
  module Services
    class Api
      include Depends.on('client')
      attr_accessor :token

      def send(request)
        client.send(request)
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

      def me
        send authenticated(ApiRequest.new('admin/me'))
      end

      def change_me(payload)
        send authenticated(ApiRequest.new('admin/me')
          .method(:patch)
          .params(payload))
      end

      def rotate_password
        send authenticated(ApiRequest.new('admin/me/password').method(:post))
      end

      def rotate_totp
        send authenticated(ApiRequest.new('admin/me/totp').method(:post))
      end

      def users
        send authenticated(ApiRequest.new('admin/admins'))
      end

      private

      def authenticated(request)
        request.header('Authorization', "Bearer #{token}")
      end
    end
  end
end
