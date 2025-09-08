# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :account do
      primary_key :id

      column :name, String, unique: true, null: false
      column :label, String, null: false
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
