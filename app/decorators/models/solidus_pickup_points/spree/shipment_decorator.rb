# frozen_string_literal: true

module SolidusPickupPoints
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.before_validation :assign_pickup_carrier, unless: :shipped?
        base.validate :pickup_point_fits_carrier
      end

      def valid_pickup?
        carrier = shipping_method&.pickup_carrier
        carrier.blank? || (pickup_carrier == carrier && SolidusPickupPoints.valid?(carrier, pickup_point_id, pickup_name))
      end

      # Switching the rate saves only the rates, so update the shipment's point with it.
      def selected_shipping_rate_id=(id)
        super
        assign_pickup_carrier
      end

      private

      # The point belongs to the selected method's carrier; a switch drops it unless a new one came along.
      def assign_pickup_carrier
        carrier = shipping_method&.pickup_carrier
        if carrier.blank? || (carrier != pickup_carrier && !will_save_change_to_pickup_point_id?)
          self.pickup_point_id = self.pickup_name = self.pickup_address = nil
        end
        self.pickup_carrier = carrier
        self.pickup_point_id = pickup_point_id.to_s.strip.presence
        self.pickup_name = pickup_name.to_s.strip.first(200).presence
        self.pickup_address = pickup_address.to_s.strip.first(300).presence
      end

      def pickup_point_fits_carrier
        return if pickup_point_id.blank? || pickup_carrier.blank?
        errors.add(:pickup_point_id, :invalid) unless SolidusPickupPoints.valid?(pickup_carrier, pickup_point_id, pickup_name)
      end

      ::Spree::Shipment.prepend self
    end
  end
end
