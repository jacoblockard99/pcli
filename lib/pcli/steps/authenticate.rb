module Pcli
  class Steps
    class Authenticate < Step
      include Depends.on('authenticate')

      spaced

      def run(_prev)
        authenticate.run ? success : failure
      end
    end
  end
end
