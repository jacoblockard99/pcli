# frozen_string_literal: true

module Pcli
  module Util
    module Cli
      class FieldsFlagsError < StandardError; end

      def self.analyze_fields_flags(all, fields, hash)
        result = {}

        is_negative = nil

        fields.each do |field|
          if all
            result[field] = true
            next
          end

          is_negative = hash[field] if is_negative.nil? && !hash[field].nil?

          if !hash[field].nil? && is_negative != hash[field]
            raise FieldsFlagsError, 'Cannot parsed mixed negative and positive flags!'
          end

          result[field] = hash[field].nil? ? !is_negative : hash[field]
        end

        result
      end
    end
  end
end
