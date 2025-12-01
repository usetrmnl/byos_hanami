# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :device do
      set_column_default :firmware_update, true
      drop_column :firmware_beta
    end
  end

  down do
    alter_table :device do
      set_column_default :firmware_update, false
      add_column :firmware_beta, :boolean, null: false, default: false
    end
  end
end
