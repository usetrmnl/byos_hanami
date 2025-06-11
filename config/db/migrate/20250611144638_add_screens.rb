# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :screens do
      primary_key :id

      column :label, String
      column :name, String, unique: true, null: false
      column :uri, String
      column :image_data, :jsonb, null: false, default: "{}"
      column :rendered, :boolean, null: false, default: true
      column :displayed, :integer, null: false, default: 0
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    add_index :screens, :image_data, type: :gin
  end
end
