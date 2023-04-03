require_relative '../output'

module Pcli
  class Output::Padded
    def self.show(input, output, screen)
      amount = 5
      messages = input

      if !messages.respond_to?(:each)
        messages = [messages]
      end

      messages = messages.flat_map { |m| m == '' ? '' : m.split("\n") }

      length = screen.width - amount
      result = ''

      messages.each do |message|
        message.each_char.with_index do |c, i|
          if i % length == 0
            if i > 0
              result += "\n"
            end
            result += ' ' * amount
          end
          result += c
        end
        result += "\n"
      end

      output.print(result)
    end
  end
end
