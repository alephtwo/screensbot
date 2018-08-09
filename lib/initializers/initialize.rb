# frozen_string_literal: true

require 'active_record'
require 'yaml'

pwd = __dir__
src_root = File.join pwd, '..', '..'

env = ENV['SCREENSBOT_ENV'] || 'development'
db_config = YAML.load_file File.join src_root, 'config', 'database.yml'

ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection env.to_sym

Dir[File.join(src_root, 'models', '*.rb')].each { |f| require f }
