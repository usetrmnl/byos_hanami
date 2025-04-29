# frozen_string_literal: true

ROM::SQL.migration do
  change do
    set_column_type :devices, :friendly_id, String
    set_column_type :devices, :label, String
    set_column_type :devices, :mac_address, String
    set_column_type :devices, :api_key, String
    set_column_type :devices, :firmware_version, String
  end
end
