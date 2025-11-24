# frozen_string_literal: true

ROM::SQL.migration do
  up do
    run "ALTER TABLE model ALTER COLUMN kind DROP DEFAULT;"
    run "ALTER TABLE model ALTER COLUMN kind TYPE TEXT USING kind::TEXT;"
    run "ALTER TABLE model ALTER COLUMN kind SET DEFAULT 'terminus';"
    run "DROP TYPE IF EXISTS model_kind_enum;"
  end

  down do
    run "ALTER TABLE model ALTER COLUMN kind DROP DEFAULT;"
    run "CREATE TYPE model_kind_enum AS ENUM ('byod', 'kindle', 'tidbyt', 'trmnl');"
    run "ALTER TABLE model ALTER COLUMN kind TYPE model_kind_enum USING kind::model_kind_enum;"
  end
end
