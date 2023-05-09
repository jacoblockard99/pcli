# frozen_string_literal: true

module Pcli
  module Services
    class App
      include Depends.on(
        'output',
        steps: 'all_steps'
      )

      def run
        result = nil
        prev_space = false
        steps.all.each.with_index do |step, i|
          break if result&.halt? && !step.ensured?

          output.puts if i.positive? && step.spaced? && !prev_space

          result = step.run(result)

          if i < steps.all.count - 1 && step.spaced?
            prev_space = true
            output.puts
          else
            prev_space = false
          end
        end
      end
    end
  end
end
