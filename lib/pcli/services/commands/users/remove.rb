# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module Users
        class Remove < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'input',
            'output',
            'screen',
            'prompt'
          )

          desc 'Remove an administrator.'

          argument :user, desc: 'The user to delete.'

          def call(user: nil, **args)
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
              user = prompt.select('Which user would you like to remove?', choices)
            end

            user = users.find { |u| u['id'] === user || u['username'].downcase === user.to_s.downcase }
            unless user
              output.puts(Pl.yellow('That user does not exist.'))
              return CommandOutput.continue
            end

            output.puts
            output.puts "This action will permanently remove #{user['name']} as an administrator."
            output.puts

            if prompt.no?(Pl.red('Are you sure you want to continue?'))
              output.puts 'Command aborted.'
              return CommandOutput.continue
            end

            spinner = nil
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Removing user...', output)
              r = api.remove_user(user['id'])
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success("User #{Pl.green('removed')}")
            else
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
