# frozen_string_literal: true

module SolidusPickupPoints
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.validate :pickup_points_chosen
      end

      private

      # Checkout cannot leave the delivery step until every pickup shipment has a point.
      def pickup_points_chosen
        return if completed_at.present? || !%w[payment confirm complete].include?(state)
        return if shipments.all?(&:valid_pickup?)
        errors.add(:base, I18n.t("solidus_pickup_points.pickup_required"))
      end

      ::Spree::Order.prepend self
    end
  end
end
