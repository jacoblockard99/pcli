# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module User
        class Totp < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'input',
            'output',
            'screen',
            'prompt',
            'qr'
          )

          desc 'Rotate the TOTP secret of the logged-in administrator.'

          def call(*)
            spinner = nil
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

            if response.failure?
              output.puts
              Output::ServerError.show(response, output, screen)
              return CommandOutput.continue
            end

            output.puts
            output.puts "This action will regenerate #{response.json['name']}'s TOTP secret and display the corresponding QR code once."
            output.puts

            if prompt.no?(Pl.red('Are you sure you want to continue?'))
              output.puts 'Command aborted.'
              return CommandOutput.continue
            end

            output.puts
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Regenerating TOTP...', output)
              r = api.rotate_totp
              if r.failure?
                spinner.failure
              end
              r
            end

            if response.success?
              spinner.success("TOTP #{Pl.green('regenerated')}")
              output.puts
              output.puts Pl.yellow('New TOTP code:')
              qr.show(response.json['totpUrl'])
              output.puts
              output.print 'Scan the QR with your authenticator app and press any key when finished...'
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
