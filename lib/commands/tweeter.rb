# frozen_string_literal: true

require 'logger'
require 'twitter'
require_relative '../util/twitter_util'

# Tweet things
module Tweeter
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO

  def self.tweet
    screenshot = find_next
    validate_path_exists(screenshot.path)
    tweet = send_tweet(screenshot.path)
    Tweet.create screenshot: screenshot, tweet_id: tweet.id
    LOGGER.info "tweeted! (id: #{tweet.id})"
  end

  def self.find_next
    screenshot = find_next_unposted
    return screenshot unless screenshot.nil?
    LOGGER.error 'screensbot: no posts found'
    abort
  end

  def self.find_next_unposted
    Screenshot.left_joins(:tweet)
              .where(tweets: { id: nil })
              .sort_by(&:order)
              .first
  end

  def self.validate_path_exists(path)
    return if File.file? path
    LOGGER.error "screensbot: path #{path} not found"
    abort
  end

  def self.upload_media(path)
    [TwitterUtil.client.upload(File.open(path))]
  rescue StandardError => e
    abort_error(e)
  end

  def self.send_tweet(path)
    TwitterUtil.client.update('', media_ids: upload_media(path).join(','))
  rescue StandardError => e
    abort_error(e)
  end

  def self.abort_error(e)
    LOGGER.error "twitter: #{e.inspect}"
    abort
  end
end
