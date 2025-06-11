# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :screen do
      primary_key :id

      foreign_key :model_id, :model, null: false, on_update: :cascade, on_delete: :cascade

      column :label, String, unique: true, null: false
      column :name, String, unique: true, index: true, null: false
      column :image_data, :jsonb, null: false, default: "{}"
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    add_index :screen, :image_data, type: :gin
  end
end
