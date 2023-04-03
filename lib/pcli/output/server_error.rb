require_relative '../output'
require_relative 'padded'

module Pcli
  class Output::ServerError
    def self.show(response, output, screen)
      result = ''

      if response.known_error?
        output.puts 'Server:'
        Output::Padded.show([
          Pl.yellow(response.error.title) + ' ' + Pl.dim("(#{response.error.status})"),
          '',
          response.error.message
        ], output, screen)
      else
        output.puts 'Server ' + Pl.yellow('(' + response.code.to_s + ')') + ':'
        Output::Padded.show(response.body, output, screen)
      end
      result
    end
  end
end
