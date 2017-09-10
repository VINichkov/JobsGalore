puts "_________________________________"
puts $redis
puts "_________________________________"
Sidekiq.configure_server do |config|
  config.redis = { url: $redis, namespace: "app3_sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis, namespace: "app3_sidekiq_#{Rails.env}" }
end