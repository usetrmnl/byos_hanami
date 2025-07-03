# frozen_string_literal: true

require_relative "../app/aspects/screens/designer/middleware"

module Terminus
  # The application base routes.
  class Routes < Hanami::Routes
    get "/", to: "dashboard.show", as: :root

    get "/api/devices", to: "api.devices.index", as: :api_devices
    get "/api/devices/:id", to: "api.devices.show", as: :api_device
    post "/api/devices", to: "api.devices.create", as: :api_device_create
    patch "/api/devices/:id", to: "api.devices.patch", as: :api_device_patch
    delete "/api/devices/:id", to: "api.devices.delete", as: :api_device_delete

    get "/api/display", to: "api.display.show", as: :api_display

    post "/api/log", to: "api.log.create", as: :api_log_create

    get "/api/models", to: "api.models.index", as: :api_models
    get "/api/models/:id", to: "api.models.show", as: :api_model
    post "/api/models", to: "api.models.create", as: :api_model_create
    patch "/api/models/:id", to: "api.models.patch", as: :api_model_patch
    delete "/api/models/:id", to: "api.models.delete", as: :api_model_delete

    get "/api/screens", to: "api.screens.index", as: :api_screens
    post "/api/screens", to: "api.screens.create", as: :api_screen_create
    delete "/api/screens/:id", to: "api.screens.delete", as: :api_screen_delete

    get "/api/setup", to: "api.setup.show", as: :api_setup

    # TODO: Remove once Firmware drops trailing slash requirement.
    get "/api/setup/", to: "api.setup.show", as: :api_setup

    delete "/bulk/devices/:device_id/logs",
           to: "bulk.devices.logs.delete",
           as: :bulk_device_logs_delete
    delete "/bulk/firmware", to: "bulk.firmware.delete", as: :bulk_firmware_delete

    get "/devices", to: "devices.index", as: :devices
    get "/devices/:id", to: "devices.show", as: :device
    get "/devices/new", to: "devices.new", as: :device_new
    post "/devices", to: "devices.create", as: :device_create
    get "/devices/:id/edit", to: "devices.edit", as: :device_edit
    put "/devices/:id", to: "devices.update", as: :device_update
    delete "/devices/:id", to: "devices.delete", as: :device_delete

    get "/devices/:device_id/logs", to: "devices.logs.index", as: :device_logs
    get "/devices/:device_id/logs/:id", to: "devices.logs.show", as: :device_log
    delete "/devices/:device_id/logs/:id", to: "devices.logs.delete", as: :device_log_delete

    get "/designer", to: "designer.show", as: :designer
    post "/designer", to: "designer.create", as: :designer_create

    get "/firmware", to: "firmware.index", as: :firmware
    delete "/firmware/:id", to: "firmware.delete", as: :firmware_delete

    get "/playlists", to: "playlists.index", as: :playlists
    get "/playlists/:id", to: "playlists.show", as: :playlist
    get "/playlists/new", to: "playlists.new", as: :playlist_new
    post "/playlists", to: "playlists.create", as: :playlist_create
    get "/playlists/:id/edit", to: "playlists.edit", as: :playlist_edit
    put "/playlists/:id", to: "playlists.update", as: :playlist_update
    delete "/playlists/:id", to: "playlists.delete", as: :playlist_delete

    get "/playlists/:id/mirror/edit", to: "playlists.mirror.edit", as: :playlist_mirror_edit
    put "/playlists/:id/mirror", to: "playlists.mirror.update", as: :playlist_mirror_update

    get "/problem_details", to: "problem_details.index", as: :problem_details

    get "/screens", to: "screens.index", as: :screens
    get "/screens/:id", to: "screens.show", as: :screen
    get "/screens/new", to: "screens.new", as: :screen_new
    post "/screens", to: "screens.create", as: :screen_create
    get "/screens/:id/edit", to: "screens.edit", as: :screen_edit

    slice(:health, at: "/up") { root to: "show" }

    use Rack::Static, root: "public", urls: ["/.well-known/security.txt", "/uploads"]
    use Aspects::Screens::Designer::Middleware, pattern: %r(/preview/(?<id>\d+))
  end
end
