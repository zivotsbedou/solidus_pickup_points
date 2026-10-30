# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Pickup points on shipments" do
  let(:order) { create(:order_with_line_items, state: "delivery") }
  let(:shipment) { order.shipments.first }
  let(:rate) { shipment.shipping_rates.first }
  let(:point) { {pickup_point_id: " 10178 ", pickup_name: "Z-BOX Korunní", pickup_address: "Korunní 1, Praha"} }

  before { rate.shipping_method.update!(carrier: "parcelbox", service_level: "pickup") }

  def deliver(attributes)
    params = ActionController::Parameters.new(order: {shipments_attributes: {"0" => {id: shipment.id, selected_shipping_rate_id: rate.id}.merge(attributes)}})
    Spree::OrderUpdateAttributes.new(order, params.require(:order).permit(Spree::PermittedAttributes.checkout_delivery_attributes)).apply
  end

  it "stores the picked point with the selected method's carrier" do
    expect(deliver(point)).to be true
    expect(shipment.reload.attributes.values_at("pickup_carrier", "pickup_point_id", "pickup_name", "pickup_address"))
      .to eq(["parcelbox", "10178", "Z-BOX Korunní", "Korunní 1, Praha"])
    expect(shipment).to be_valid_pickup
  end

  it "rejects a code that does not fit the carrier" do
    expect(deliver(point.merge(pickup_point_id: "10178; x"))).to be false
    expect(shipment.reload.pickup_point_id).to be_nil
  end

  it "drops the point when the customer switches to a method without one" do
    deliver(point)
    home = shipment.shipping_rates.create!(shipping_method: create(:shipping_method), cost: 0)
    params = ActionController::Parameters.new(order: {shipments_attributes: {"0" => {id: shipment.id, selected_shipping_rate_id: home.id}}})
    expect(Spree::OrderUpdateAttributes.new(order.reload, params.require(:order).permit(Spree::PermittedAttributes.checkout_delivery_attributes)).apply).to be true
    expect(shipment.reload.attributes.values_at("pickup_carrier", "pickup_point_id", "pickup_name", "pickup_address")).to all(be_nil)
  end

  it "drops the point when its method stops delivering to pickup points" do
    deliver(point)
    rate.shipping_method.update!(service_level: nil)
    shipment.reload.save!
    expect(shipment.attributes.values_at("pickup_carrier", "pickup_point_id", "pickup_name", "pickup_address")).to all(be_nil)
  end

  it "keeps checkout at delivery until each pickup shipment has a point" do
    expect(order.next).to be false
    expect(order.errors[:base]).to include(I18n.t("solidus_pickup_points.pickup_required"))
    deliver(point)
    expect(order.reload.next).to be true
  end
end
