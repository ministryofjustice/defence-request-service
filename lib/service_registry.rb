class ServiceRegistry
  ServiceNotRegistered = Class.new(ArgumentError)

  def self.register(name, service)
    services.store(name, service)
  end

  def self.service(name)
    services.fetch(name) do
      raise ServiceNotRegistered.new("Service #{name} is not registered")
    end
  end

  def self.services
    ServiceRegistryStore
  end
end

class ServiceRegistryStore
  class << self
    extend Forwardable
    def_delegators :services, :fetch, :store

    private

    def services
      @store ||= {}
    end
  end
end
