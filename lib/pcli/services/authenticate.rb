# frozen_string_literal: true

module Pcli
  module Services
    class Authenticate
      include ActionView::Helpers::DateHelper

      include Depends.on(
        'output', 'prompt', 'api', 'screen'
      )

      def run(should_prompt = true)
        if should_prompt
          output.puts Pl.dim('Please login.')
          output.puts
        end

        username = prompt.ask('Username:')
        password = prompt.mask('Password:')
        totp = prompt.ask('TOTP Code:')
        output.puts

        spinner = SimpleSpinnerBar.start('Authenticating...', output)
        response = api.auth(username, password, totp)

        if response.success?
          api.token = response.json['token']
          expires_at = DateTime.parse(response.json['expiresAt'])
          time = distance_of_time_in_words(DateTime.now, expires_at)

          spinner.success("#{Pl.green('Authenticated')} for the next #{Pl.yellow(time)}")
          true
        else
          spinner.failure

          output.puts
          if response.known_error?
            if response.error.type == 'invalid_credentials'
              output.puts Pl.yellow('Invalid credentials!')
              output.puts
              return run(false)
            end

            puts 'Server:'
            Output::Padded.show([
                                  "#{Pl.yellow(response.error.title)} #{Pl.dim("(#{response.error.status})")}",
                                  '',
                                  response.error.message
                                ], output, screen)
          else
            output.puts "Server #{Pl.yellow("(#{response.code})")}:"
            output.puts Output::Padded.show(response.body, output, screen)
          end

          false
        end
      end
    end
  end
end
