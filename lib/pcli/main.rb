require 'pastel'
require 'tty-screen'
require_relative 'options'
require_relative 'app'
require_relative 'api'
require_relative 'prompt'
require_relative 'steps'
require_relative 'depends'
require_relative 'container'
require_relative 'authenticate'

module Pcli
  class Main
    def run(args)
      options = Options.parse(args)

      container = Container.new.tap do |c|
        c.register_instance 'config.endpoint', options[:endpoint]
        c.register_instance 'input', STDIN
        c.register_instance 'output', STDOUT
        c.register_instance 'screen', TTY::Screen
        c.register 'authenticate', Authenticate
        c.register 'api', Api
        c.register 'prompt', Prompt
        c.register 'app', App
        c.register 'steps', Steps
        c.register 'steps.greeting', Steps::Greeting
        c.register 'steps.connect', Steps::Connect
        c.register 'steps.authenticate', Steps::Authenticate
        c.register 'steps.valediction', Steps::Valediction
      end

      container.resolve('app').run
    end
  end
end
