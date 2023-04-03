require_relative '../version'
require_relative '../step'
require_relative '../depends'
require_relative '../pl'

module Pcli
  class Steps
    class Greeting < Step
      include Depends.on('output')

      spaced

      def run(_prev)
        output.puts "The Ponsqb Admin CLI #{Pl.green('v' + Pcli::VERSION)}, at your service!"
        success
      end
    end
  end
end
