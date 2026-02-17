# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :device_sensor_kind, %w[carbon_dioxide humidity pressure temperature]
    create_enum :device_sensor_source, %w[device server]

    create_table :device_sensor do
      primary_key :id

      foreign_key :device_id,
                  :device,
                  index: true,
                  null: false,
                  on_delete: :cascade,
                  on_update: :cascade

      column :make, String, null: false
      column :model, String, null: false
      column :kind, :device_sensor_kind, index: true, null: false
      column :value, :float, null: false, default: 0
      column :unit, String, null: false
      column :source, :device_sensor_source, index: true, null: false, default: "device"

      column :created_at,
             :timestamp,
             null: false,
             default: Sequel.function(:date_trunc, "second", Sequel::CURRENT_TIMESTAMP)
    end
  end
end
