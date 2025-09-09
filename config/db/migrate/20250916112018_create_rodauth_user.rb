# frozen_string_literal: true

ROM::SQL.migration do
  up do
    extension :date_arithmetic

    deadline = lambda do |days|
      {null: false, default: Sequel.date_add(Sequel::CURRENT_TIMESTAMP, days:)}
    end

    # Feature (automatic): base
    create_table :user_status do
      primary_key :id

      column :name, String, unique: true, null: false
    end

    from(:user_status).import(%i[id name], [[1, "Unverified"], [2, "Verified"], [3, "Closed"]])

    create_table :user do
      primary_key :id, type: :Bignum
      foreign_key :status_id, :user_status, null: false, default: 1

      column :name, String
      citext :email, null: false
      column :settings, :jsonb, null: false, default: "{}"
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP

      constraint :valid_email, email: /^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/

      index :email, unique: true, where: {status_id: [1, 2]}
      index :settings, type: :gin
    end

    # Feature: active_sessions
    create_table :user_active_session_key do
      foreign_key :user_id, :user, type: :Bignum

      column :session_id, String
      column :created_at, Time, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :last_use, Time, null: false, default: Sequel::CURRENT_TIMESTAMP

      primary_key %i[user_id session_id]
    end

    # Feature: audit_logging
    create_table :user_authentication_audit_log do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :user, null: false, type: :Bignum

      column :at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :message, String, null: false
      column :metadata, :jsonb

      index %i[user_id at], name: :audit_user_at_idx
      index :at, name: :audit_at_idx
    end

    # Feature: jwt_refresh
    create_table :user_jwt_refresh_key do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :user, null: false, type: :Bignum

      column :key, String, null: false
      column :deadline, DateTime, deadline.call(1)

      index :user_id, name: :user_jwt_refresh_key_user_id_idx
    end

    # Feature: recovery_codes
    create_table :user_recovery_code do
      foreign_key :id, :user, type: :Bignum

      column :code, String

      primary_key %i[id code]
    end

    # Feature: remember
    create_table :user_remember_key do
      foreign_key :id, :user, primary_key: true, type: :Bignum

      column :key, String, null: false
      column :deadline, DateTime, deadline.call(14)
    end

    run %(GRANT REFERENCES ON "user" TO CURRENT_USER)
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_status TO CURRENT_USER"
    run %(GRANT SELECT, INSERT, UPDATE, DELETE ON "user" TO CURRENT_USER)
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_active_session_key TO CURRENT_USER"
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_authentication_audit_log TO CURRENT_USER"
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_jwt_refresh_key TO CURRENT_USER"
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_recovery_code TO CURRENT_USER"
    run "GRANT SELECT, INSERT, UPDATE, DELETE ON user_remember_key TO CURRENT_USER"
  end

  down do
    drop_table :user_remember_key,
               :user_recovery_code,
               :user_jwt_refresh_key,
               :user_authentication_audit_log,
               :user_active_session_key,
               :user_status,
               :user
  end
end
