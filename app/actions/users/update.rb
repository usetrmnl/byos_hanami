# frozen_string_literal: true

module Terminus
  module Actions
    module Users
      # The update action.
      class Update < Terminus::Action
        include Deps[repository: "repositories.user", show_view: "views.users.show"]

        params do
          required(:id).filled :integer

          required(:user).filled(:hash) do
            required(:name).filled :string
            required(:email).filled :string
          end
        end

        def handle request, response
          parameters = request.params
          user = repository.find parameters[:id]

          halt :unprocessable_entity unless user

          if parameters.valid?
            save user, parameters, response
          else
            error user, parameters, response
          end
        end

        private

        def save user, parameters, response
          id = user.id
          repository.update id, **parameters[:user]

          response.render show_view, user: repository.find(id), layout: false
        end

        def error user, parameters, response
          response.render view,
                          user:,
                          fields: parameters[:user],
                          errors: parameters.errors[:user],
                          layout: false
        end
      end
    end
  end
end
