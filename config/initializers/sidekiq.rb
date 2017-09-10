Sidekiq.configure_server do |config|
  config.redis = { url: $redis, namespace: "app3_sidekiq_#{Rails.env}" }
end
