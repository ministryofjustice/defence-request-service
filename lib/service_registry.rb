class ServiceRegistry
  ServiceNotRegistered = Class.new(ArgumentError)

  def self.register(name, service)
    services[name] = service
  end

  def self.service(name)
    services.fetch(name) do
      raise ServiceNotRegistered.new("Service #{name} is not registered")
    end
  end

  def self.services
    @services ||= {}
  end
end
