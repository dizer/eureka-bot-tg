source 'https://rubygems.org'
gemspec

gem 'activesupport', '>= 5.0.0'
gem 'eureka-bot', git: 'git@bitbucket.org:styletransfer/eureka-bot.git'
gem 'telegram-bot-ruby', require: 'telegram/bot', github: 'dizer/telegram-bot-ruby'

group :development, :test do
  gem 'rspec',       '~> 3.5.0'
  gem 'spring'
  gem 'factory_girl'
end

group :test do
  gem 'webmock'
  # gem 'vcr'
end
