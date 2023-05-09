# frozen_string_literal: true

module Pcli
  class SimpleSpinnerBar
    def self.start(template, output)
      new(template, output).tap(&:start)
    end

    def initialize(template, output)
      @template = template
      @spinner = TTY::Spinner.new(
        '[:spinner] :template',
        format: :dots,
        interval: 20,
        output: output
      )
    end

    def start
      spinner.update(template: template)
      spinner.auto_spin
    end

    def success(new_template = false)
      spinner.update(template: new_template) if new_template
      spinner.success
    end

    def failure(new_template = false)
      spinner.update(template: new_template) if new_template
      spinner.error(Pl.red('(failed)'))
    end

    private

    attr_reader :template, :spinner
  end
end
