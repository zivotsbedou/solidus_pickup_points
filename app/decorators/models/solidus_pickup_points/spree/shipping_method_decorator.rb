# frozen_string_literal: true

module SolidusPickupPoints
  module Spree
    module ShippingMethodDecorator
      # The carrier whose point the customer picks, when the method delivers to a registered pickup carrier.
      def pickup_carrier
        carrier if service_level == "pickup" && SolidusPickupPoints.config.carriers.key?(carrier)
      end

      ::Spree::ShippingMethod.prepend self
    end
  end
end
