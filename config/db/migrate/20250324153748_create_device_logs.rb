# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :wifi_status_enum,
                %w[
                  no_shield
                  idle_status
                  no_ssid_avail
                  scan_completed
                  connected
                  connect_failed
                  connection_lost
                  disconnected
                ]

    create_enum :special_function_enum,
                %w[identify sleep add_wifi restart_playlist rewind send_to_me none]

    create_enum :wake_reason_enum,
                %w[
                  powercycle
                  all
                  EXT0
                  EXT1
                  timer
                  touchpad
                  ulp
                  button
                  uart
                  wifi
                  cocpu
                  cocpu_trap_trig
                  bt
                ]

    create_table :device_logs do
      primary_key :id

      foreign_key :device_id,
                  :devices,
                  index: true,
                  null: false,
                  on_delete: :cascade,
                  on_update: :cascade

      column :external_id, :integer, null: false
      column :message, String, null: false
      column :source_path, String, null: false
      column :source_line, :integer, null: false
      column :retry, :integer, null: false, default: 0
      column :wifi_signal, :integer, null: false, default: 0
      column :wifi_status, :wifi_status_enum, index: true, null: false, default: "disconnected"
      column :refresh_rate, :integer, null: false, default: 0
      column :sleep_duration, :integer, null: false, default: 0
      column :firmware_version, String, null: false
      column :special_function, :special_function_enum, index: true, null: false, default: "none"
      column :wake_reason, :wake_reason_enum, index: true, null: false, default: "timer"
      column :battery_voltage, :float, null: false, default: 0
      column :free_heap_size, :integer, null: false, default: 0
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
