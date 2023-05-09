# frozen_string_literal: true

module Pcli
  module Services
    module Steps
      class Authenticate < Step
        include Depends.on('authenticate')

        spaced

        def run(_prev)
          authenticate.run ? success : failure
        end
      end
    end
  end
end
