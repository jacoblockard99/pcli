module Pcli
  class Container
    def initialize
      @registrations = {}
      @instances = {}
    end

    def register(name, type)
      @registrations[name] = type
    end

    def register_instance(name, instance)
      @instances[name] = instance
    end

    def resolve(name, originator = nil)
      return @instances[name] if @instances.has_key? name

      raise "Unregistered dependency \"#{name}\"" unless @registrations.has_key? name

      dependencies = @registrations[name].dependencies.map do |dependency|
        raise "Circular dependency \"#{dependency}\"" if originator && dependency == originator

        [dependency.to_sym, resolve(dependency, originator)]
      end.to_h

      @instances[name] = @registrations[name].new(**dependencies)
    end
  end
end
