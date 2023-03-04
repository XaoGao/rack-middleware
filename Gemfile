# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.2"

gem "json", "~> 2.3"
gem "oj", "~> 3.14", ">= 3.14.2"
gem "puma", "~> 6.1", ">= 6.1.1"
gem "rack", "~> 3.0", ">= 3.0.4.1"
gem "rackup", "~> 2.1"

group :development do
  gem "rspec", "~> 3.12"
  gem "rubocop", "~> 1.39", require: false
  gem "rubocop-performance", "~> 1.11", require: false
  gem "rubocop-rspec", "~> 2.15", require: false
end

group :test do
  gem "rack-test", "~> 2.0", ">= 2.0.2"
  gem "simplecov", require: false
end
