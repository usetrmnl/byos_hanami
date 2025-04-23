# frozen_string_literal: true

ROM::SQL.migration do
  change { add_column :device_logs, :max_alloc_size, :integer, null: false, default: 0 }
end
