# frozen_string_literal: true

module Terminus
  # The application base routes.
  class Routes < Hanami::Routes
    get "/", to: "dashboard.show", as: :root

    get "/api/display/", to: "api.display.show", as: :api_display_show
    post "/api/screens", to: "api.screens.create", as: :api_screens_create
    post "/api/log", to: "api.log.create", as: :api_log_create
    get "/api/setup/", to: "api.setup.show", as: :api_setup_show

    get "/devices", to: "devices.index", as: :devices_index
    get "/devices/:id", to: "devices.show", as: :devices_show
    get "/devices/new", to: "devices.new", as: :devices_new
    post "/devices", to: "devices.create", as: :devices_create
    get "/devices/:id/edit", to: "devices.edit", as: :devices_edit
    put "/devices/:id", to: "devices.update", as: :devices_update
    delete "/devices/:id", to: "devices.delete", as: :devices_delete

    get "/devices/:device_id/logs", to: "devices.logs.index", as: :devices_logs_index
    get "/devices/:device_id/logs/:id", to: "devices.logs.show", as: :devices_logs_show

    slice(:health, at: "/up") { root to: "show" }

    use Rack::Static, root: "public", urls: ["/.well-known/security.txt"]
  end
end
