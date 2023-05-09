# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module Users
        class List < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'output',
            'screen'
          )

          desc 'Get a list of all admin users.'

          def call(*)
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

            if response.success?
              spinner.success
              output.puts
              output.puts TTY::Table.new(
                header: [
                  Pl.bold('ID'), Pl.bold('Username'), Pl.bold('Name')
                ],
                rows: response.json.map { |u| [u['id'], u['username'], u['name']] }
              ).render(:ascii)
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
