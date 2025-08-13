# frozen_string_literal: true

ROM::SQL.migration do
  change do
    add_column :model, :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    add_column :model, :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
  end
end
