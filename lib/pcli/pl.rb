module Pcli
  class Pl
    @base = Pastel.new

    class << self
      delegate_missing_to :base
      
      private

      attr_reader :base
    end
  end
end
