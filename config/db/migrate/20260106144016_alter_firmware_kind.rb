# frozen_string_literal: true

ROM::SQL.migration do
  up do
    run "ALTER TABLE firmware ALTER COLUMN kind DROP DEFAULT;"
    run "ALTER TABLE firmware ALTER COLUMN kind TYPE TEXT USING kind::TEXT;"
    run "ALTER TABLE firmware ALTER COLUMN kind SET DEFAULT 'terminus';"
    run "DROP TYPE IF EXISTS firmware_kind_enum;"
  end
end
