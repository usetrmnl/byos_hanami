# frozen_string_literal: true

Hanami.app.register_provider :trmnl_api do
  prepare { require "trmnl/api" }

  start do
    recipes = TRMNL::API.new { |settings| settings.uri = "https://trmnl.com" }

    register :trmnl_api, TRMNL::API.new
    register :trmnl_api_recipes, recipes
  end
end
