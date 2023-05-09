# frozen_string_literal: true

module Dry
  class CLI
    def exit(code); end

    def perform_registry(arguments)
      result = registry.get(arguments)
      return usage(result) unless result.found?

      command, args = parse(result.command, result.arguments, result.names)

      result.before_callbacks.run(command, args)
      output = command.call(**args)
      result.after_callbacks.run(command, args)

      output
    end
  end
end

module Pcli
  module Services
    class Commander
      include Depends.on('output', commands: 'all_commands')

      def initialize(**args)
        super

        @cli = Dry::CLI.new(commands.registry)
      end

      def run(cmd)
        @cli.call(arguments: cmd.split, out: output, err: output)
      end
    end
  end
end
