# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module User
        class Show < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'output',
            'screen'
          )

          desc 'Display information about the logged-in administrator.'

          def call(*)
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Retrieving user...', output)
              r = api.me
              if r.failure?
                spinner.failure
              else
                spinner.success
              end
              r
            end

            if response.success?
              output.puts
              output.puts TTY::Table.new(rows: [
                                           [Pl.bold('ID'), response.json['id']],
                                           [Pl.bold('Name'), response.json['name']],
                                           [Pl.bold('Username'), response.json['username']]
                                         ]).render(:ascii)
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
