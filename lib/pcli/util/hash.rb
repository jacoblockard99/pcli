# frozen_string_literal: true

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
        raise message unless hash.key?(key)

        hash[key]
      end

      def self.has_keys?(hash, *keys)
        keys.all? { |k| hash.key?(k) }
      end
    end
  end
end
