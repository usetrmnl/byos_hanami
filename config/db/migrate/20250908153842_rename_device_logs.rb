# frozen_string_literal: true

ROM::SQL.migration { change { rename_table :device_logs, :device_log } }
