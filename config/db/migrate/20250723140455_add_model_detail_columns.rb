# frozen_string_literal: true

ROM::SQL.migration do
  change do
    add_column :model, :mime_type, String, null: false, default: "image/png"
    add_column :model, :colors, :integer, null: false, default: 2
    add_column :model, :bit_depth, :integer, null: false, default: 1
    add_column :model, :scale_factor, :integer, null: false, default: 1
    add_column :model, :rotation, :integer, null: false, default: 0
    add_column :model, :offset_x, :integer, null: false, default: 0
    add_column :model, :offset_y, :integer, null: false, default: 0
  end
end
