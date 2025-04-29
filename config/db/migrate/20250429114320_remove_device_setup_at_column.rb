# frozen_string_literal: true

ROM::SQL.migration { change { drop_column :devices, :setup_at } }
