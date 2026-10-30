# frozen_string_literal: true

class AddPickupPointToSpreeShipments < ActiveRecord::Migration[7.0]
  COLUMNS = %i[pickup_carrier pickup_point_id pickup_name pickup_address].freeze

  def up
    COLUMNS.each do |column|
      # Shops that stored points before this extension keep their columns and data.
      add_column :spree_shipments, column, :string unless column_exists?(:spree_shipments, column)
    end
  end

  # The columns may predate the extension and hold live points, so rollback leaves them.
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
