# frozen_string_literal: true

ROM::SQL.migration do
  change { add_column :devices, :proxy, :boolean, null: false, default: false }
end
