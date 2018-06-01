source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
gem 'bootstrap', '~> 4.1.0'
gem 'carrierwave'
gem 'cocoon'
gem 'skim'
gem 'gon'
gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper', '4.2.6'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'therubyracer'
gem 'sidekiq'
gem 'whenever'
gem 'unicorn'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  # gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'json_spec'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara-webkit'
end
