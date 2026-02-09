# frozen_string_literal: true

ROM::SQL.migration do
  change do
    add_column :model, :palette_ids, "text[]", null: false, default: "{}"
    add_column :model, :css, :jsonb, null: false, default: "{}"
  end
end
