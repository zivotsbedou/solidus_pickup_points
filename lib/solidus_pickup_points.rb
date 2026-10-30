# frozen_string_literal: true

require "solidus_pickup_points/configuration"
require "solidus_pickup_points/version"
require "solidus_pickup_points/engine"

module SolidusPickupPoints
  ATTRIBUTES = %i[pickup_point_id pickup_name pickup_address].freeze

  # True when the code fits the carrier's registered format and the point has a name.
  def self.valid?(carrier, code, name)
    config.carriers[carrier]&.match?(code.to_s) && name.present?
  end
end
