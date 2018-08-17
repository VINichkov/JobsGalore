source 'https://rubygems.org'

ruby '2.5.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'#, '~> 5.0.4'#, '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg'#, '~> 0.18'

# Use Puma as the app server

# Use SCSS for stylesheets
gem 'sass-rails'#, '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'#, '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'#, '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem "activerecord-import"
# Use react as the JavaScript library
gem 'react-rails'#, '~>1.10.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "font-awesome-rails"
gem "sitemap_generator"
gem 'redis-objects'
gem 'aasm'
gem 'rack-rewrite'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'#, '~> 2.5'
gem 'bootstrap-sass'#, '~> 3.3.6'
gem 'jquery-rails'
gem 'will_paginate'#, '~> 3.1.0'
gem 'social-share-button'
gem 'cancancan'#, '~> 2.0.0'
gem 'devise','~> 4.4.3'
gem 'dkim'
gem 'markitdown'
gem 'interactor'
gem 'omniauth-linkedin-oauth2'
#gem 'linkedin'


gem 'twitter'
gem 'will_paginate-bootstrap'# ,'~> 1.0.1'
#gem 'bcrypt', '~>3.1.11'

gem "html_truncator"#, "~>0.4"
gem 'slim-rails'
gem 'slim'

gem 'dragonfly'#, '~> 1.1.1'
gem 'mechanize'
gem 'virtus'

gem "pg_search"#, '~> 2.0.1'
#gem "actionpack-page_caching"


# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt'#, '~> 3.1.7'
gem 'draper'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'webrick'
  gem 'web-console'
  gem 'listen'#, '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'#, '~> 2.0.0'


end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
#gem 'spreadsheet'
gem 'markdown-rails'

#gem 'sidekiq'
#gem 'redis'
#gem 'redis-namespace'
group :production do
  gem 'dragonfly-s3_data_store'
  gem "asset_sync"
  gem "fog-aws"
  gem 'puma'
  gem 'heroku-deflater'
end