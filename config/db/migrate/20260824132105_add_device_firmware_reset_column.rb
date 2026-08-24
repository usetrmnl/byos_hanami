# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://hanakai.org/learn/hanami/database/migrations/ for details.
  change { add_column :device, :firmware_reset, :boolean, null: false, default: false }
end
