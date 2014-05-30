source 'https://rubygems.org'

gem 'dotenv',     '~> 0.11.1' # Reads .env file for configuration variables
gem 'json',       '~> 1.8.1'  # Parse JSON
gem 'pi_piper', github: 'jwhitehorn/pi_piper', ref: '1b31cda43a' # GPIO Library for interfacing with hardware
gem 'rb-inotify', '~> 0.9.4', require: false  # File event watcher for linux
gem 'rb-fsevent', '~> 0.9.4', require: false  # File event watcher for mac
gem 'typhoeus',   '~> 0.6.8'  # HTTP library for REST calls

group :development, :test do
  gem 'rake'
  gem 'rb-readline'
  gem 'pry-awesome_print' # Auto AP in pry
  gem 'pry-plus'          # Add a bunch of awesome pry stuff (rescue, stack_explorer, doc)
end

group :test do
  gem 'autotest' # Run 'autotest' to continually run your tests on change
  gem 'minitest'
end
