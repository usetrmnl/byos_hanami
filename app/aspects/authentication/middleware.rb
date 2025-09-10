# frozen_string_literal: true

require "roda"
require "rodauth"

module Main
  class AuthenticationApp < Roda
    plugin :middleware

    plugin :rodauth do
      enable :login, :logout

      db Main::Slice["db.gateway"].connection
      use_database_authentication_functions? false
      account_password_hash_column :password_hash
    end

    route do |r|
      r.rodauth
      env["rodauth"] = rodauth
    end

    # Renders templates with layout.
    def view options
      template = options.fetch :template
      return super unless view_template? template

      # TODO: do something with title, possibly provide as a local to the layout?

      view_rendering.template(
        base_view.class.layout_path(base_view.config.layout),
        view_rendering.scope(options.fetch(:locals))
      ) { render options }
    end

    # Renders templates without layout.
    def render options
      template = options.fetch :template
      return super unless view_template? template

      view_rendering.template(
        view_template_name(template),
        view_rendering.scope(options.fetch(:locals))
      )
    end

    private

    def view_template? template_name
      view_rendering.renderer.__send__ :lookup,
                                       view_template_name(template_name),
                                       base_view.config.default_format
    end

    def view_template_name template_name
      "authentication_app/#{template_name.tr "-", "_"}"
    end

    def view_rendering
      @view_rendering ||= base_view.rendering(
        format: base_view.config.default_format,
        context: base_view.config.default_context
      )
    end

    def base_view
      @base_view ||= Class.new(Main::View).new
    end
  end
end
