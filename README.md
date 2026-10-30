# Solidus Pickup Points

Customers often collect parcels at a carrier's pickup point or parcel box. Carriers offer their own
pickers for choosing one. This extension keeps the chosen point on the Solidus shipment:

- **Shipment snapshot.** `spree_shipments` gets `pickup_carrier`, `pickup_point_id`, `pickup_name`
  and `pickup_address`. Later changes in the carrier's network do not change a placed order.
- **Checkout.** The point arrives with the delivery step's `shipments_attributes`, which the
  extension permits. The code must fit the carrier's format. The order cannot leave the delivery
  step until every pickup shipment has a point.
- **Switching methods.** A shipment that switches to another carrier or to home delivery drops its
  old point.
- **Admin.** The legacy admin shows the point under each shipment.

Carrier extensions register their carrier. [solidus_packeta](https://github.com/zivotsbedou/solidus_packeta)
does so for Packeta.

## Installation

```ruby
gem 'solidus_pickup_points', github: 'zivotsbedou/solidus_pickup_points'
```

```shell
bin/rails generate solidus_pickup_points:install
```

The migration adds only the columns a shop does not have yet, so a shop that stored points itself
keeps its data.

## Configuration

A shipping method delivers to pickup points when its service level is `pickup` and its carrier is
registered with the format of that carrier's point codes:

```ruby
SolidusPickupPoints.configure do |config|
  config.carriers["balikovna"] = /\A\d{5}\z/
end
```

## Storefront

Solidus extensions do not change the storefront, so add the picker to your delivery step. Send the
point as fields of the shipment the customer is choosing for:

```erb
<%= form.fields_for :shipments do |ship_form| %>
  <% ship_form.object.shipping_rates.each do |rate| %>
    <%= ship_form.radio_button :selected_shipping_rate_id, rate.id,
          data: {carrier: rate.shipping_method.pickup_carrier} %>
  <% end %>
  <%= ship_form.hidden_field :pickup_point_id %>
  <%= ship_form.hidden_field :pickup_name %>
  <%= ship_form.hidden_field :pickup_address %>
<% end %>
```

Open the carrier's picker for the checked rate's `data-carrier` and fill the three fields from its
result. Only accept the picker's own callback or a message whose origin and source match its frame.
Use `shipment.pickup_name` and `shipment.pickup_address` in confirmation and shipping e-mails.

## Development

```shell
bin/rake          # builds spec/dummy on the first run, then runs the specs
bundle exec rubocop
```

## License

Copyright (c) 2026 Život s Béďou, z.s., released under the BSD 3-Clause License.
