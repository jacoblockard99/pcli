require 'tty-prompt'
require 'active_support/core_ext/module/delegation'

module Pcli
  class Prompt
    delegate_missing_to :base

    def initialize(input:, output:)
      @base = TTY::Prompt.new(input: input, output: output)
    end

    def self.dependencies
      ['input', 'output']
    end

    private

    attr_reader :base
  end
end
