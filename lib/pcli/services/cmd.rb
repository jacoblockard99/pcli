# frozen_string_literal: true

module Pcli
  module Services
    class Cmd
      include Depends.on('output')

      def new(**options)
        TTY::Command.new(output: output, **options)
      end
    end
  end
end
