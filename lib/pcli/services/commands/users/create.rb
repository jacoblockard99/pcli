# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module Users
        class Create < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'input',
            'output',
            'screen',
            'prompt'
          )

          desc 'Create a new administrator.'

          def call(**args)
            payload = {}

            name = prompt.ask('Name')
            payload['name'] = name

            username = prompt.ask('Username')
            payload['username'] = username

            spinner = nil
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Creating user...', output)
              r = api.create_user(payload)
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success("User #{Pl.green('created')}")

              output.puts
              output.puts Pl.yellow('New password: ') + response.json['password']
              output.puts
              output.print 'Copy the password and press any key when finished...'
              input.gets
              output.clear_screen

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
