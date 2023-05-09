# frozen_string_literal: true

module Pcli
  module Services
    class Prompt
      delegate_missing_to :base

      def initialize(input:, output:)
        @base = TTY::Prompt.new(input: input, output: output)
      end

      def self.dependencies
        %w[input output]
      end

      private

      attr_reader :base
    end
  end
end
