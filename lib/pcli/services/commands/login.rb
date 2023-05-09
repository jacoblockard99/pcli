module Pcli
  module Services
    module Commands
      class Login < Dry::CLI::Command
        include Depends.on('authenticate', 'api', 'prompt', 'output')

        desc 'Log in.'

        def call(*)
          if api.token && !prompt.yes?('You are already logged in. Would you like to log out?')
            output.puts('Aborted.')
            return
          end

          authenticate.run(true)

          CommandOutput.continue
        end
      end
    end
  end
end
