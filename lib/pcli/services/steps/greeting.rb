# frozen_string_literal: true

module Pcli
  module Services
    module Steps
      class Greeting < Step
        include Depends.on('output')

        spaced

        def run(_prev)
          output.puts "The Ponsqb Admin CLI #{Pl.green("v#{Pcli::VERSION}")}, at your service!"
          success
        end
      end
    end
  end
end
