require_relative 'steps/greeting'
require_relative 'steps/connect'
require_relative 'steps/authenticate'
require_relative 'steps/valediction'

module Pcli
  class Steps
    include Depends.on(
      'steps.greeting',
      'steps.connect',
      'steps.authenticate',
      'steps.valediction'
    )

    def all
      [
        greeting,
        connect,
        authenticate,
        valediction
      ]
    end
  end
end
