# frozen_string_literal: true

module Pcli
  module Output
    class ServerError
      def self.show(response, output, screen)
        result = ''

        if response.known_error?
          output.puts 'Server:'
          Output::Padded.show([
                                "#{Pl.yellow(response.error.title)} #{Pl.dim("(#{response.error.status})")}",
                                '',
                                response.error.message
                              ], output, screen)
        else
          output.puts "Server #{Pl.yellow("(#{response.code})")}:"
          Output::Padded.show(response.body, output, screen)
        end
        result
      end
    end
  end
end
