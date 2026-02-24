# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      # A capsule of content and errors.
      Capsule = Data.define :content, :errors do
        def initialize content: {}, errors: {}
          super
        end

        def clear = members.each { public_send(it).clear }

        def errors? = errors.any?
      end
    end
  end
end
