# frozen_string_literal: true

ROM::SQL.migration do
  up { alter_table(:device_log) { set_column_type :sleep_duration, :bigint } }

  down do
    run <<~SQL
      ALTER TABLE device_log
      ALTER COLUMN sleep_duration TYPE integer
      USING TRUNC(sleep_duration)::integer
    SQL
  end
end
