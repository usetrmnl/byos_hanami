# frozen_string_literal: true

ROM::SQL.migration do
  up { drop_column :model, :published_at }
  down { add_column :model, :published_at, :timestamp }
end
