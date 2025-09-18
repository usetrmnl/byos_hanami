# frozen_string_literal: true

user_status_table = Hanami.app["db.gateway"].connection[:user_status]

if user_status_table.to_a.empty?
  user_status_table.multi_insert [
    {id: 1, name: "Unverified"},
    {id: 2, name: "Verified"},
    {id: 3, name: "Closed"}
  ]
else
  puts "User status seeds exist. Skipped."
end
