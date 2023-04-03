module Pcli
  class Step
    class << self
      def ensured
        @ensured = true
      end

      def ensured?
        @ensured == nil ? @ensured = false : @ensured
      end

      def ensured
        @ensured = true
      end

      def spaced?
        @spaced == nil ? @spaced = false : @spaced
      end

      def spaced()
        @spaced = true
      end
    end

    class Result
      def initialize(success, halt, code)
        @success = success
        @halt = halt
        @code = code
      end

      def success?
        @success
      end

      def halt?
        @halt
      end

      def code(value = nil)
        if value
          @code = value
          self
        else
          @code
        end
      end

      def halt(value = true)
        @halt = value
        self
      end
    end

    delegate :ensured?, :spaced?, to: :class

    protected

    def success
      Result.new(true, false, 0)
    end

    def failure(code = 1)
      Result.new(false, true, code)
    end
  end
end
