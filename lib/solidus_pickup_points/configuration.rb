# frozen_string_literal: true

module SolidusPickupPoints
  class Configuration
    # Point code format per shipping method carrier, e.g. { "packeta" => /\A\d{1,10}\z/ }.
    # A shipping method with service level "pickup" and a registered carrier needs a point.
    attr_accessor :carriers

    def initialize
      @carriers = {}
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias_method :config, :configuration

    def configure
      yield configuration
    end
  end
end
