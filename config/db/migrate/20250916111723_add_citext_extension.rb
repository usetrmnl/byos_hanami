# frozen_string_literal: true

ROM::SQL.migration do
  up { run "CREATE EXTENSION IF NOT EXISTS citext" }

  down { run "DROP EXTENSION IF EXISTS citext" }
end
