# frozen_string_literal: true

require "rodauth/migrations"

ROM::SQL.migration do
  settings = {table_name: :user_password_hash}

  up do
    # Feature (automatic): base
    create_table :user_password_hash do
      foreign_key :id, :user, primary_key: true, type: :Bignum
      column :password_hash, String, null: false
    end

    Rodauth.create_database_authentication_functions self, **settings

    run "REVOKE ALL ON user_password_hash FROM public"
    run "REVOKE ALL ON FUNCTION rodauth_get_salt(int8) FROM public"
    run "REVOKE ALL ON FUNCTION rodauth_valid_password_hash(int8, text) FROM public"
    run "GRANT INSERT, UPDATE, DELETE ON user_password_hash TO CURRENT_USER"
    run "GRANT SELECT(id) ON user_password_hash TO CURRENT_USER"
    run "GRANT EXECUTE ON FUNCTION rodauth_get_salt(int8) TO CURRENT_USER"
    run "GRANT EXECUTE ON FUNCTION rodauth_valid_password_hash(int8, text) TO CURRENT_USER"
  end

  down { Rodauth.drop_database_authentication_functions self, **settings }
end
