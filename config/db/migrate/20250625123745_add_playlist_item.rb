# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :playlist_item_repeat_type_enum, %w[none minute hour day week month year]

    create_table :playlist_item do
      primary_key :id

      foreign_key :playlist_id, :playlist, null: false, on_update: :cascade, on_delete: :cascade
      foreign_key :screen_id, :screen, null: false, on_update: :cascade, on_delete: :cascade

      column :position, Integer, null: false
      column :repeat_interval, Integer, null: false, default: 1
      column :repeat_type,
             :playlist_item_repeat_type_enum,
             index: true,
             null: false,
             default: "none"
      column :repeat_days, "integer[]", null: false, default: "{}"
      column :last_day_of_month, :boolean, null: false, default: false
      column :start_at, :timestamp, index: true
      column :stop_at, :timestamp, index: true
      column :hidden_at, :timestamp
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    add_index :playlist_item, %i[playlist_id position], unique: true
  end
end
