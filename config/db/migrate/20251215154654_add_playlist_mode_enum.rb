# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_enum :playlist_mode_enum, %w[automatic manual]
    add_column :playlist, :mode, :playlist_mode_enum, index: true, null: false, default: "automatic"
  end
end
