# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :screen do
      drop_foreign_key [:device_id]
      add_foreign_key [:device_id], :device, on_update: :cascade, on_delete: :set_null
    end
  end

  down do
    alter_table :screen do
      drop_foreign_key [:device_id]
      add_foreign_key [:device_id], :device, on_update: :cascade, on_delete: :cascade
    end
  end
end
