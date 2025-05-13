# frozen_string_literal: true

require_relative "../app/aspects/screens/editor/middleware"

module Terminus
  # The application base routes.
  class Routes < Hanami::Routes
    get "/", to: "dashboard.show", as: :root

    get "/api/display", to: "api.display.show", as: :api_display
    post "/api/screens", to: "api.screens.create", as: :api_screens_create
    post "/api/log", to: "api.log.create", as: :api_log_create
    get "/api/setup/", to: "api.setup.show", as: :api_setup

    delete "/bulk/devices/:device_id/logs",
           to: "bulk.devices.logs.delete",
           as: :bulk_device_logs_delete
    delete "/bulk/firmware", to: "bulk.firmware.delete", as: :bulk_firmware_delete

    get "/devices", to: "devices.index", as: :devices
    get "/devices/:id", to: "devices.show", as: :device_show
    get "/devices/new", to: "devices.new", as: :device_new
    post "/devices", to: "devices.create", as: :device_create
    get "/devices/:id/edit", to: "devices.edit", as: :device_edit
    put "/devices/:id", to: "devices.update", as: :device_update
    delete "/devices/:id", to: "devices.delete", as: :device_delete

    get "/devices/:device_id/logs", to: "devices.logs.index", as: :device_logs
    get "/devices/:device_id/logs/:id", to: "devices.logs.show", as: :device_log_show
    delete "/devices/:device_id/logs/:id", to: "devices.logs.delete", as: :device_log_delete

    get "/designer", to: "designer.show", as: :designer
    post "/designer", to: "designer.create", as: :designer_create

    get "/firmware", to: "firmware.index", as: :firmware
    delete "/firmware/:version", to: "firmware.delete", as: :firmware_delete

    slice(:health, at: "/up") { root to: "show" }

    use Rack::Static, root: "public", urls: ["/.well-known/security.txt"]
    use Aspects::Screens::Editor::Middleware, pattern: %r(/preview/(?<id>\d+))
  end
end
