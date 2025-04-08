# frozen_string_literal: true

ROM::SQL.migration do
  change { add_column :devices, :firmware_update, :boolean, null: false, default: false }
end
