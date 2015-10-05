module Moose
  class Processor

    def initialize(services)
      @services = services
    end

    def process(json)
      @services.each do |service|
        warn "Running #{service.class.name}"
        json = service.process(json)
      end

      json
    end

  end
end