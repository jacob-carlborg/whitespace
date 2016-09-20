source 'https://rubygems.org'

# Specify your gem's dependencies in whitespace.gemspec
gemspec

RUBY2_PLATFORMS = [:ruby_20, :ruby_21, :ruby_22, :ruby_23].freeze

group :development, :test do
  gem 'pry-byebug', '~> 3.4.0', platforms: RUBY2_PLATFORMS
  gem 'rubocop', '~> 0.43.0', platforms: RUBY2_PLATFORMS

  gem 'pry-debugger', '~> 0.2.3', platforms: :ruby_19
end
