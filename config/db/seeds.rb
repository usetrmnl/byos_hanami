# frozen_string_literal: true

Hanami.app["db.gateway"]
      .connection[:user_status]
      .insert_conflict
      .multi_insert [
        {id: 1, name: "Unverified"},
        {id: 2, name: "Verified"},
        {id: 3, name: "Closed"}
      ]
