# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :screen do
      set_column_type :kind, String
      set_column_default :kind, "general"
    end

    run "DROP TYPE IF EXISTS screen_kind_enum;"
  end
end
