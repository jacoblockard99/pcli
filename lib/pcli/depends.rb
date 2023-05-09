# frozen_string_literal: true

module Pcli
  module Depends
    def self.on(*names, **kw_names)
      Module.new do
        class_methods = Module.new do
          define_method :dependencies do
            names + kw_names.values
          end
        end

        define_singleton_method :included do |base|
          base.extend class_methods
        end

        names.each do |name|
          method_name = name.split('.').last

          define_method(method_name) { @_dependencies[name] }
        end

        kw_names.each do |method_name, name|
          define_method(method_name) { @_dependencies[name] }
        end

        define_method :initialize do |**args|
          @_dependencies = self.class.dependencies.map { |n| [n, nil] }.to_h

          args.each do |key, value|
            key = key.to_s
            raise "#{self.class.name} given invalid dependency \"#{key}\"" unless @_dependencies.key?(key)

            @_dependencies[key] = value
          end
          @_dependencies.each_key do |n|
            raise "#{self.class.name} missing dependency \"#{n}\"" unless args.key?(n.to_sym)
          end
        end
      end
    end
  end
end
