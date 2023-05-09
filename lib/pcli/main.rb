# frozen_string_literal: true

module Pcli
  class Main
    def run(args)
      options = Options.parse(args)

      container = Container.new.tap do |c|
        c.register_instance 'config.endpoint', options[:endpoint]
        c.register_instance 'input', $stdin
        c.register_instance 'output', $stdout
        c.register_instance 'screen', TTY::Screen
        c.register_instance 'which', TTY::Which
        c.register_instance 'editor', TTY::Editor

        c.register_module Services
      end

      container.resolve('app').run
    end
  end
end
