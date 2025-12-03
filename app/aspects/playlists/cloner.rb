# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Playlists
      # Clones an existing playlist.
      class Cloner
        include Deps[
          repository: "repositories.playlist",
          item_repository: "repositories.playlist_item"
        ]
        include Dry::Monads[:result]

        def call(id, **overrides)
          original = repository.with_items.by_pk(id).one
          attributes = {label: "#{original.label} Clone", name: "#{original.name}_clone"}

          Success create(attributes, overrides, original)
        rescue ROM::SQL::UniqueConstraintError => error
          build_failure error.message
        end

        private

        def create attributes, overrides, original
          repository.create(attributes.merge!(overrides)).tap do |clone|
            add_associations clone, original
          end
        end

        def add_associations clone, original
          cloned_items = add_items clone, original
          curent_screen_id = original.current_item.then { it.screen_id if it }

          return unless curent_screen_id

          add_current_item clone, cloned_items, curent_screen_id
        end

        def add_items clone, original
          original.playlist_items.each do |item|
            item_repository.create playlist_id: clone.id, **item.cloneable_attributes
          end
        end

        def add_current_item clone, cloned_items, curent_screen_id
          cloned_items.find { |item| item.screen_id == curent_screen_id }
                      .then do |current_item|
                        repository.update clone.id, current_item_id: current_item.id
                      end
        end

        def build_failure message
          match = message.match(/Key \((?<key>[^)]+)\)/)
          Failure match[:key].to_sym => ["must be unique"]
        end
      end
    end
  end
end
