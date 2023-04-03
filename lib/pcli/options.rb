require 'tty-option'

module Pcli
  class Options
    class TTYOption
      include TTY::Option

      usage do
        program 'ponsqb'

        desc 'Launch the Ponsqb admin CLI.'
      end

      option :endpoint do
        short '-e'
        long '--endpoint string'
        default 'https://ponsqb.provisionsbs.com'
        desc 'Ponsqb endpoint.'
      end

      flag :help do
        short '-h'
        long '--help'
        desc 'Print usgae.'
      end

      def evaluate
        if params[:help]
          print help
          exit
        end

        params.to_h
      end
    end

    def self.parse(args)
      TTYOption.new.parse(args).evaluate
    end
  end
end
