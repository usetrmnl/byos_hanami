# frozen_string_literal: true

ROM::SQL.migration do
  up { drop_column :model, :scale_factor }
  down { add_column :model, :scale_factor, :float, null: false, default: 1 }
end
