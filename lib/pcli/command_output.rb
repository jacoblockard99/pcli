# frozen_string_literal: true

module Pcli
  class CommandOutput
    class << self
      def halt
        new(true)
      end

      def continue
        new(false)
      end
    end

    def initialize(halt)
      @halt = halt
    end

    def halt?
      @halt
    end
  end
end
