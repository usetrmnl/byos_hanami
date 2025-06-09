# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :firmware_kind_enum, %w[beta stable]

    create_table :firmwares do
      primary_key :id

      column :version, String, unique: true, null: false
      column :kind, :firmware_kind_enum, null: false, default: "stable"
      column :attachment_data, :jsonb, null: false, default: "{}"
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    add_index :firmwares, :attachment_data, type: :gin
  end
end
