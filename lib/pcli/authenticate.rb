require_relative 'simple_spinner_bar'

module Pcli
  class Authenticate
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
        expires_at = DateTime.parse(response.json['expiresAt'])
        time = distance_of_time_in_words(DateTime.now, expires_at)

        spinner.success("#{Pl.green('Authenticated')} for the next #{Pl.yellow(time)})")
        true
      else
        spinner.failure

        output.puts
        if response.known_error?
          if response.error.type == 'invalid_credentials'
            output.puts Pl.yellow('Invalid credentials!')
            output.puts
            run(false)
            return
          end

          puts 'Server:'
          Output::Padded.show([
            Pl.yellow(response.error.title) + ' ' + Pl.dim("(#{response.error.status})"),
            '',
            response.error.message
          ], output, screen)
        else
          output.puts 'Server ' + Pl.yellow('(' + response.code.to_s + ')') + ':'
          output.puts Output::Padded.show(response.body, output, screen)
        end

        false
      end
    end
  end
end
