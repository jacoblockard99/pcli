# frozen_string_literal: true

module Pcli
  module Services
    module Steps
      class Valediction < Step
        include Depends.on('output')

        spaced

        def run(prev)
          if prev.success?
            output.puts "Goodbye! PCLI finished with code #{Pl.green(prev.code)}"
          else
            output.puts "PCLI finished with error code #{Pl.red(prev.code)}"
          end
        end
      end
    end
  end
end
