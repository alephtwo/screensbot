# frozen_string_literal: true

require 'twitter'

# Twitter Utility
module TwitterUtil
  def self.client
    pwd = __dir__
    config_file = File.join pwd, '..', '..', 'config', 'twitter.yml'
    tweet_config = YAML.load_file config_file
    Twitter::REST::Client.new do |config|
      config.consumer_key = tweet_config['consumer_key']
      config.consumer_secret = tweet_config['consumer_secret']
      config.access_token = tweet_config['access_token']
      config.access_token_secret = tweet_config['access_token_secret']
    end
  end
end
