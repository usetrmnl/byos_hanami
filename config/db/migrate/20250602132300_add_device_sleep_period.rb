# frozen_string_literal: true

ROM::SQL.migration do
  change do
    add_column :devices, :sleep_start_at, :time
    add_column :devices, :sleep_end_at, :time
  end
end
