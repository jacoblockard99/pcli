# frozen_string_literal: true

module Pcli
  module Services
    class AllSteps
      include Depends.on(
        'steps.greeting',
        'steps.connect',
        'steps.main',
        'steps.valediction'
      )

      def all
        [
          greeting,
          connect,
          main,
          valediction
        ]
      end
    end
  end
end
