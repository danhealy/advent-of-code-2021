source "https://rubygems.org"

ruby "3.0.1"

gem "slop"
gem 'sorbet-runtime'

group :development do
  gem 'sorbet'
  gem 'tapioca', require: false
end

group :development, :test do
  gem "rubocop"
  gem "rspec"
  gem "rubocop-rspec"
  gem 'rubocop-sorbet', require: false
  gem "pry"
end
