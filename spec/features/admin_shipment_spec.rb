# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Pickup point in the admin shipment", type: :feature do
  stub_authorization!

  it "shows the carrier, code, name and address" do
    order = create(:order_ready_to_ship)
    order.shipments.first.update_columns(pickup_carrier: "parcelbox", pickup_point_id: "10178",
      pickup_name: "Z-BOX Korunní", pickup_address: "Korunní 1, Praha")

    visit spree.edit_admin_order_path(order)

    within("[data-hook='admin_shipment_pickup_point']") do
      expect(page).to have_text("parcelbox / 10178 — Z-BOX Korunní, Korunní 1, Praha")
    end
  end
end
