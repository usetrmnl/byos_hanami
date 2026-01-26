# frozen_string_literal: true

ROM::SQL.migration do
  up { alter_table(:device) { set_column_not_null :model_id } }
  down { alter_table(:device) { set_column_allow_null :model_id } }
end
