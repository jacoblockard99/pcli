# frozen_string_literal: true

module Pcli
  module Services
    module Steps
      class Main < Step
        include Depends.on(
          'input',
          'output',
          'commander'
        )

        spaced

        def initialize(**args)
          super

          @cmd_prompt = TTY::Prompt.new(
            input: input,
            output: output,
            enable_color: false
          )
        end

        def run(_)
          output.puts while _run

          success
        end

        private

        attr_reader :cmd_prompt

        def _run
          cmd = cmd_prompt.ask("#{Pl.blue('pcli')}>")

          begin
            result = commander.run(cmd) || CommandOutput.continue
            !result.halt?
          rescue StandardError => e
            output.puts(Pl.red('Exception occurred during command!'))
            output.puts
            output.puts(e.full_message)
            true
          end
        end
      end
    end
  end
end
