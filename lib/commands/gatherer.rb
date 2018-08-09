# frozen_string_literal: true

require_relative '../util/twitter_util'
require_relative '../util/collectable'
require 'set'

# Gather them metrics
module Gatherer
  include Collectable

  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO

  CLIENT = TwitterUtil.client
  MAX_TWEETS = Twitter::REST::Timelines::MAX_TWEETS_PER_REQUEST
  BATCH_SIZE = MAX_NUM_RESULTS * (MAX_PAGE - 1)

  def self.update_metrics
    timeline = gather_timeline
    tweets = Tweet.all
    tweets_by_id = tweets.group_by(&:tweet_id)

    find_updates(timeline, tweets).each do |id, v|
      LOGGER.info "updating tweet with id #{id}"
      tweets_by_id[id].first.update(favorites: v[:favs], retweets: v[:rts])
    end
  end

  def self.gather_timeline
    Collectable.collect_with_count(BATCH_SIZE) do |opts|
      CLIENT.user_timeline(CLIENT.user.screen_name, opts)
    end
  end

  def self.find_updates(timeline, tweets)
    tweeted_ids = tweets.map(&:tweet_id).to_set
    timeline
      .select { |t| tweeted_ids.include?(t.id.to_s) }
      .map { |t| [t.id.to_s, { favs: t.favorite_count, rts: t.retweet_count }] }
      .to_h
  end
end
