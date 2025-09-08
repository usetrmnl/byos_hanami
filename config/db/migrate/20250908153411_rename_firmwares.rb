# frozen_string_literal: true

ROM::SQL.migration { change { rename_table :firmwares, :firmware } }
