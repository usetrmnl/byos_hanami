# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :user do
      primary_key :id

      column :email, String, unique: true, index: true, null: false
      column :name, String, null: false
      column :password_digest, String, null: false
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
