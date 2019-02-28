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
# Use react as the JavaScript library
gem 'react-rails', '~>2.4.7'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "font-awesome-rails"
gem 'redis-objects'
gem 'aasm'
gem 'pdf-reader','~> 2.1.0'
gem 'prawn'
gem 'oga'
gem "oink"
gem 'tinymce-rails'
#gem 'pdf2html'
#gem 'origami'
gem "docx"
gem "ffi"


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'#, '~> 2.5'
gem 'bootstrap-sass'#, '~> 3.3.6'
gem 'jquery-rails'
gem 'will_paginate'#, '~> 3.1.0'
gem 'social-share-button'
gem 'cancancan'#, '~> 2.0.0'
gem 'devise','~> 4.4.3'
gem 'dkim'
gem 'interactor'
gem 'omniauth-linkedin-oauth2', '~> 0.2.5'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

gem 'rubyzip'

gem 'twitter'
gem 'will_paginate-bootstrap'# ,'~> 1.0.1'

gem "html_truncator"#, "~>0.4"
gem 'slim'

gem 'dragonfly', '~> 1.1.5'
gem 'mechanize'
gem 'virtus'

gem "pg_search"#, '~> 2.0.1'


# Use Redis adapter to run Action Cable in production
# Use ActiveModel has_secure_password
gem 'bcrypt'#, '~> 3.1.7'
gem 'draper'
gem 'figaro'
# Use Capistrano for deployment




group :development, :test do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-figaro',   require: false
  gem 'capistrano-rails-console',   require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console

  gem 'byebug', platform: :mri
  gem 'web-console'
  gem 'listen'#, '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'#, '~> 2.0.0'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
group :production do

  gem 'dragonfly-s3_data_store'
  gem "asset_sync"
  gem "fog-aws"
  gem 'puma'
end