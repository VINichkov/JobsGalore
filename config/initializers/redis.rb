if ENV["RAILS_ENV"]=="production"
  $redis=ENV["REDIS_URL"]
else
  $redis = 'redis://localhost:6379/0'
end
