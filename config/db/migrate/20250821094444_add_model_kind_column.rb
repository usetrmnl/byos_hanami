# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :model_kind_enum, %w[terminus core]
    add_column :model, :kind, :model_kind_enum, index: true, null: false, default: "terminus"
  end
end
