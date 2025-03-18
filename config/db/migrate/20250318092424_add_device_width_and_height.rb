# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :devices do
      add_column :width, :integer, null: false, default: 0
      add_column :height, :integer, null: false, default: 0
    end
  end
end
