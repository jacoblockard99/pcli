# frozen_string_literal: true

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

    def register_module(m, hierarchy = [])
      m.constants.each do |name|
        c = m.const_get(name)
        h = hierarchy.clone
        h << name.to_s.underscore.downcase
        next unless c.is_a?(Module)

        if c.is_a?(Class)
          registration_name = h.join('.')
          register registration_name, c
        end
        register_module(c, h)
      end
    end

    def resolve(name, originator = nil)
      originator ||= name

      return @instances[name] if @instances.key? name

      raise "Unregistered dependency \"#{name}\"" unless @registrations.key? name

      registration = @registrations[name]
      dependencies = {}

      if registration.respond_to?(:dependencies)
        dependencies = registration.dependencies.map do |dependency|
          raise "Circular dependency \"#{dependency}\"" if originator && dependency == originator

          [dependency.to_sym, resolve(dependency, originator)]
        end.to_h
      end

      @instances[name] = @registrations[name].new(**dependencies)
    end
  end
end
