# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :extension_model do
      primary_key :id

      foreign_key :extension_id, :extension, null: false, on_delete: :cascade, on_update: :cascade
      foreign_key :model_id, :model, null: false, on_delete: :cascade, on_update: :cascade

      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    add_index :extension_model, %i[extension_id model_id], unique: true
  end
end
