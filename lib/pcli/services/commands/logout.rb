module Pcli
  module Services
    module Commands
      class Logout < Dry::CLI::Command
        include Depends.on('authenticate', 'api', 'output')

        desc 'Log out.'

        def call(*)
          unless api.token
            output.puts('You are not logged in.')
            return
          end

          api.token = nil

          output.puts(Pl.green('Logged out.'))

          CommandOutput.continue
        end
      end
    end
  end
end
