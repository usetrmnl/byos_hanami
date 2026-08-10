# frozen_string_literal: true

ROM::SQL.migration { up { alter_table(:screen) { drop_index :device_id_kind } } }
