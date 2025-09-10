# auto_register: false
# frozen_string_literal: true

require "roda"
require "rodauth"

require_relative "feature"

module Terminus
  module Aspects
    module Authentication
      # Specialized Roda middleware for authentication.
      class Middleware < Roda
        Hanami.app.start :mail

        plugin :middleware

        # rubocop:todo Metrics/BlockLength
        plugin :rodauth do
          enable :active_sessions,
                 :audit_logging,
                 :change_login,
                 :change_password,
                 :change_password_notify,
                 :create_account,
                 :email_auth,
                 :hanami,
                 :jwt_refresh,
                 :lockout,
                 :login,
                 :logout,
                 :remember,
                 :recovery_codes,
                 :reset_password,
                 :verify_account,
                 :verify_login_change

          db Sequel.connect(ENV.fetch("DATABASE_URL", nil))

          # Feature (automatic): base
          accounts_table :user
          after_login { remember_login }
          already_logged_in { redirect "/" }
          flash_error_key :alert
          hmac_secret Hanami.app[:settings].app_secret
          login_label "Email"
          no_matching_login_message "no matching account"
          password_hash_table :user_password_hash
          require_login_error_flash "Please sign in to continue"
          template_opts layout: nil
          unverified_account_message "unverified account, please verify before signing in"

          # Feature (automatic): login_password_requirements_base
          require_password_confirmation? false

          # Feature: active_sessions
          active_sessions_account_id_column :user_id
          active_sessions_table :user_active_session_key

          # Feature: audit_logging
          audit_logging_table :user_authentication_audit_log
          audit_logging_account_id_column :user_id

          # Feature: change_login
          change_login_route "account/change-email"

          # Feature: change_password
          change_password_route "account/change-password"

          # Feature: change_password_notify

          # Feature: create_account
          create_account_link_text "Sign up"
          create_account_route "register"
          create_account_view { view "register", "Register" }

          # Feature: email_auth
          email_auth_table :user_email_auth_key

          # Feature (custom): hanami
          hanami_view(proc { View.new })

          # Feature: jwt
          jwt_secret Hanami.app[:settings].app_secret

          # Feature: jwt_refresh
          jwt_refresh_token_account_id_column :user_id
          jwt_refresh_token_table :user_jwt_refresh_key

          # Feature: lockout
          account_lockouts_table :user_lockout
          account_login_failures_table :user_login_failure

          # Feature: login
          login_error_flash "There was an error signing in"
          login_form_footer_links_heading { nil }
          login_notice_flash "You have been logged in"
          login_return_to_requested_location? true
          multi_phase_login_view { view "login_multi_phase", "Login Multi-Phase" }

          # Feature: logout
          logout_button "Sign out"
          logout_notice_flash "You have been logged out"
          logout_redirect "/"

          # Feature: remember
          remember_table :user_remember_key
          remember_route nil

          # Feature: recovery_codes
          recovery_codes_table :user_recovery_code

          # Feature: reset_password
          reset_password_button "Reset password"
          reset_password_request_button "Send me a reset link"
          reset_password_request_link_text "Forgot password?"
          reset_password_request_route "password/reset"
          reset_password_table :user_password_reset_key
          reset_password_request_view { view "password_reset", "Password Reset" }

          # Feature: verify_account
          verify_account_resend_link_text "Resend my account verification"
          verify_account_resend_route "resend-verify-account"
          verify_account_table :user_verification_key
          verify_account_set_password? false
          resend_verify_account_view { view "user_verify", "User Verify" }
          verify_account_resend_button "Resend Verification Email"

          # Feature: verify_login_change
          verify_login_change_table :user_login_change_key
          verify_login_change_route "verify-email-change"
        end
        # rubocop:enable Metrics/BlockLength

        route do |request|
          env["rodauth"] = rodauth
          request.rodauth
        end
      end
    end
  end
end
