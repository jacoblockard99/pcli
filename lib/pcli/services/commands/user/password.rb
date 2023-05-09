# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module User
        class Password < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'input',
            'output',
            'screen',
            'prompt'
          )

          desc 'Rotate the password of the logged-in administrator.'

          def call(*)
            spinner = nil
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Retrieving user...', output)
              r = api.me
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success
            else
              output.puts
              Output::ServerError.show(response, output, screen)
              return CommandOutput.continue
            end

            output.puts
            output.puts "This action will regenerate #{response.json['name']}'s password and display it once."
            output.puts

            if prompt.no?(Pl.red('Are you sure you want to continue?'))
              output.puts 'Command aborted.'
              return CommandOutput.continue
            end

            output.puts
            spinner = nil
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Regenerating password...', output)
              r = api.rotate_password
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success("Password #{Pl.green('regenerated')}")
              output.puts
              output.puts Pl.yellow('New password: ') + response.json['password']
              output.puts
              output.print 'Copy the password and press any key when finished...'
              input.gets
              output.clear_screen
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
