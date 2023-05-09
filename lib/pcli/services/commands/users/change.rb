# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module Users
        class Change < Dry::CLI::Command
          @field_options = []

          class << self
            attr_reader :field_options

            def field_option(name, *args, **kw_args)
              @field_options << name
              option name, *args, **kw_args
            end
          end

          include Depends.on(
            'api',
            'api_manager',
            'output',
            'screen',
            'prompt'
          )

          desc 'Change name or username of an administrator.'

          argument :user, desc: 'The user id or username to change.'
          
          field_option :name, type: :boolean, default: nil, desc: 'Whether to change the name'
          field_option :username, type: :boolean, default: nil, desc: 'Whether to change the username'

          option :all, type: :boolean, default: false, desc: 'Change all fields'

          def call(user: nil, all:, **args)
            field_args = args.slice(*self.class.field_options)

            spinner = nil
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Retrieving users...', output)
              r = api.users
              if r.failure?
                spinner.failure
              else
                spinner.success
              end
              r
            end

            if response.failure?
              output.puts
              Output::ServerError.show(response, output, screen)
              return
            end

            users = response.json

            unless user
              choices = users.map { |u| { name: "#{u['name']} (#{u['username']})", value: u['id'] } }
              user = prompt.select('Which user would you like to change?', choices)
            end

            user = users.find { |u| u['id'] === user || u['username'].downcase === user.to_s.downcase }
            unless user
              output.puts(Pl.yellow('That user does not exist.'))
              return CommandOutput.continue
            end

            fields = nil

            if all == false && field_args.empty?
              fields = prompt
                       .multi_select('Which fields do you want to change?', self.class.field_options)
                       .map { |n| [n, true] }
                       .to_h
            else
              begin
                fields = Util::Cli.analyze_fields_flags(all, self.class.field_options, field_args)
              rescue Util::Cli::FieldsFlagsError => e
                output.puts Pl.yellow(e.message)
                return CommandOutput.continue
              end
            end

            payload = {}

            if fields[:name]
              name = prompt.ask('Name', default: user['name'])
              payload['name'] = name if name != user['name']
            end

            if fields[:username]
              username = prompt.ask('Username', default: user['username'])
              payload['username'] = username if username != user['username']
            end

            if payload.empty?
              output.puts Pl.yellow('Nothing to change!')
              return CommandOutput.continue
            end

            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Changing user...', output)
              r = api.change_user(user['id'], payload)
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success("User #{Pl.green('changed')}")

              output.puts
              output.puts TTY::Table.new(rows: [
                                           [Pl.bold('ID'), response.json['id']],
                                           [Pl.bold('Name'), response.json['name']],
                                           [Pl.bold('Username'), response.json['username']]
                                         ]).render(:ascii)
            else
              spinner.failure

              output.puts
              Output::ServerError.show(response, output, screen)
            end

            CommandOutput.continue
          end
        end
      end
    end
  end
end
