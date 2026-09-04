# frozen_string_literal: true

Hanami.app.register_provider :superfluid, namespace: true do
  prepare { require "superfluid" }

  start do
    default = Superfluid.new do |environment|
      environment.merge_filters(Terminus::Aspects::Superfluid::Filters::Container)
                 .register_tag(:template, Superfluid::Tags::Template)
    end

    sanitize = lambda do |template, data|
      slice["aspects.sanitizer"].call default.call(template, data)
    end

    register :default, default
    register :sanitize, sanitize
  end
end
