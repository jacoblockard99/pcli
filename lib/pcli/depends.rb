module Pcli
  module Depends
    def self.on(*names)
      Module.new do
        class_methods = Module.new do
          define_method :dependencies do
            names
          end
        end

        define_singleton_method :included do |base|
          base.extend class_methods
        end

        names.each do |name|
          method_name = name.split('.').last

          define_method(method_name) { @_dependencies[name] }
        end

        define_method :initialize do |**args|
          @_dependencies = names.map { |n| [n, nil] }.to_h

          args.each do |key, value|
            key = key.to_s
            if @_dependencies.has_key?(key)
              @_dependencies[key] = value
            else
              raise "#{self.class.name} given invalid dependency \"#{key}\""
            end
          end
          @_dependencies.keys.each do |n|
            unless args.has_key?(n.to_sym)
              raise "#{self.class.name} missing dependency \"#{n}\""
            end
          end
        end
      end
    end
  end
end
