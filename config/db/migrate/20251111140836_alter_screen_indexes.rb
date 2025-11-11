# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :screen do
      drop_constraint :screen_name_key
      drop_constraint :screen_label_key
      drop_index :name
    end

    add_index :screen, %i[model_id name], unique: true
  end
end
