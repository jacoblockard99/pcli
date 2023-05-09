# frozen_string_literal: true

module Pcli
  module Output
    class Padded
      def self.show(input, output, screen)
        amount = 5
        messages = input

        messages = [messages] unless messages.respond_to?(:each)

        messages = messages.flat_map { |m| m == '' ? '' : m.split("\n") }

        length = screen.width - amount
        result = ''

        messages.each do |message|
          message.each_char.with_index do |c, i|
            if (i % length).zero?
              result += "\n" if i.positive?
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
end
