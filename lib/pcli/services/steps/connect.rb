# frozen_string_literal: true

module Pcli
  module Services
    module Steps
      class Connect < Step
        include Depends.on(
          'config.endpoint',
          'api',
          'output',
          'screen'
        )

        spaced

        def run(_prev)
          spinner = SimpleSpinnerBar.start("Connecting to #{endpoint}", output)

          response = api.info

          if response.success?
            v = response.json['version']
            spinner.success("#{Pl.green('Connected')} to #{endpoint}, #{Pl.yellow("v#{v}")}")
            success
          else
            spinner.failure
            output.puts
            Output::ServerError.show(response, output, screen)
            failure
          end
        end
      end
    end
  end
end
