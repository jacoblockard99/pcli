# frozen_string_literal: true

module Pcli
  module Services
    class Qr
      include Depends.on('cmd', 'output', 'which')

      def show(content)
        if which.exist?('qr')
          out, err = cmd.new(pty: true, printer: :null).run(" qr '#{content}'")
          output.puts out
        else
          output.puts RQRCode::QRCode.new(code).as_ansi
        end
      end
    end
  end
end
