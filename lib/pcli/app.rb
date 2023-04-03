require_relative 'depends'

module Pcli
  class App
    include Depends.on(
      'steps',
      'output'
    )

    def run
      result = nil
      prev_space = false
      steps.all.each.with_index do |step, i|
        break if result && result.halt? && !step.ensured?

        output.puts if i > 0 && step.spaced? && !prev_space

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
