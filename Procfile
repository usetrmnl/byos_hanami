web: bundle exec puma --config ./config/puma.rb
assets: bundle exec hanami assets compile
migrate: bundle exec hanami db migrate
worker: bundle exec sidekiq -r ./config/sidekiq.rb
firmware_poller: bin/pollers/firmware
screen_poller: bin/pollers/screen
model_poller: bin/pollers/model
