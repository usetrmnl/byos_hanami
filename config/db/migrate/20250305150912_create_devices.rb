# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :devices do
      primary_key :id
      column :friendly_id, :text
      column :label, :text
      column :mac_address, :text
      column :api_key, :text
      column :firmware_version, :text
      column :firmware_beta, :boolean, null: false, default: false
      column :wifi, :integer, null: false, default: 0
      column :battery, :float, null: false, default: 0
      column :refresh_rate, :integer, null: false, default: 900
      column :image_timeout, :integer, null: false, default: 0
      column :width, :integer, null: false, default: 0
      column :height, :integer, null: false, default: 0
      column :setup_at, :timestamp
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
