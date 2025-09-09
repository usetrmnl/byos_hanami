# frozen_string_literal: true

ROM::SQL.migration do
  change do
    run "ALTER TYPE model_kind_enum ADD VALUE IF NOT EXISTS 'byod';"
    run "ALTER TYPE model_kind_enum ADD VALUE IF NOT EXISTS 'kindle';"
    run "ALTER TYPE model_kind_enum ADD VALUE IF NOT EXISTS 'trmnl';"
  end
end
