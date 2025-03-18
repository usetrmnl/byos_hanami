# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :devices do
      rename_column :battery_voltage, :battery
      rename_column :rssi, :signal
    end
  end
end
