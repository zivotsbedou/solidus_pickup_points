# frozen_string_literal: true

require "solidus_core"
require "solidus_support"
require "deface"

module SolidusPickupPoints
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name "solidus_pickup_points"

    # Checkout sends the point with the shipment's other delivery attributes.
    initializer "solidus_pickup_points.permitted_attributes" do
      attributes = Spree::PermittedAttributes.shipment_attributes
      attributes.concat(SolidusPickupPoints::ATTRIBUTES - attributes)
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
