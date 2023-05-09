# frozen_string_literal: true

module Pcli
  module Services
    class AllCommands
      include Depends.on(
        user_show: 'commands.user.show',
        user_change: 'commands.user.change',
        user_password: 'commands.user.password',
        user_totp: 'commands.user.totp',
        users_list: 'commands.users.list',
        login: 'commands.login',
        logout: 'commands.logout',
      )

      def registry
        me = self

        Module.new do
          extend Dry::CLI::Registry

          register 'user', aliases: %w[me myself profile] do |p|
            p.register 'show', me.user_show, aliases: %w[sh view]
            p.register 'change', me.user_change, aliases: %w[ch chng update up modify mod]
            p.register 'password', me.user_password, aliases: %w[passwd pass pwd pw]
            p.register 'totp', me.user_totp, aliases: %w[code otp]
          end

          register 'users', aliases: %w[admins u] do |p|
            p.register 'list', me.users_list, aliases: %w[l all index]
          end

          register 'login', me.login, aliases: %w[signin authenticate auth]
          register 'logout', me.logout, aliases: %w[signout deauthenticate deauth unauthenticate unauth]
        end
      end
    end
  end
end
