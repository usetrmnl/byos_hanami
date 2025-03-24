# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :devices do
      add_column :image_timeout, :integer, null: false, default: 0
    end
  end
end
