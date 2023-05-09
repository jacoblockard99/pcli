# frozen_string_literal: true

module Pcli
  module Services
    class ApiManager
      include Depends.on('output', 'authenticate', 'api')

      def ensure_authenticated(&block)
        unless api.token
          return ensure_authenticated(&block) if authenticate.run(true)
        end

        response = block.call

        return if response === false

        if response.failure? && response.known_error? && response.error.type == 'unauthenticated'
          output.puts
          output.puts(Pl.dim("You've been logged out. Please log in again."))
          output.puts
          return ensure_authenticated(&block) if authenticate.run(false)
        else
          response
        end
      end
    end
  end
end
