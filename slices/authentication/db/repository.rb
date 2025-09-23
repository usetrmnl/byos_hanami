# frozen_string_literal: true

require "hanami/db/repo"

module Authentication
  module DB
    # The application database base repository.
    class Repository < Terminus::DB::Repo
    end
  end
end
