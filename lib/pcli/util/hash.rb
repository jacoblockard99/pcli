module Pcli
  module Util
    class Hash
      def self.require(hash, key, message = nil)
        message ||= "The key \"#{key}\" must exist in the hash #{hash}"
        raise message unless hash[key]

        hash[key]
      end

      def self.require_presence(hash, key, message = nil)
        message ||= "The key \"#{key}\" must be present in the hash #{hash}"
        raise message unless hash.has_key?(key)

        hash[key]
      end

      def self.has_keys?(hash, *keys)
        keys.all? { |k| hash.has_key?(k) }
      end
    end
  end
end
