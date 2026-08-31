# frozen_string_literal: true

Hanami.app.register_provider :superfluid, namespace: true do
  prepare { require "superfluid" }

  start do
    environment = Superfluid.build do |instance|
      instance.register_tag(:template, Superfluid::Tags::Template)
              .register_filters(**Terminus::Aspects::Superfluid::Filters::Container.each.to_h)
    end

    default = Superfluid.new(environment:)

    sanitize = lambda do |template, data|
      slice["aspects.sanitizer"].call default.call(template, data)
    end

    register :default, default
    register :sanitize, sanitize
  end
end
