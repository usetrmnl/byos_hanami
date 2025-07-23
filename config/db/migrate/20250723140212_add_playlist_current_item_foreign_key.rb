# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :playlist do
      add_foreign_key :current_item_id, :playlist_item, on_update: :cascade, on_delete: :set_null
    end
  end
end
