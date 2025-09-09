# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :membership do
      primary_key :id

      foreign_key :account_id,
                  :account,
                  index: true,
                  null: false,
                  on_delete: :cascade,
                  on_update: :cascade

      foreign_key :user_id,
                  :user,
                  index: true,
                  null: false,
                  on_delete: :cascade,
                  on_update: :cascade

      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
