# frozen_string_literal: true

require_relative '../util/twitter_util'

# Finalize the run
module Finalizer
  CLIENT = TwitterUtil.client
  TPR = Twitter::REST::Tweets::MAX_TWEETS_PER_REQUEST

  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO

  def self.finalize
    # TODO: Fetch as many tweets as I can get in a single API request
    # (Tweets#MAX_TWEETS_PER_REQUEST) and batch these calls.
    Tweet.all.each_slice(TPR) do |tweets|
      begin
        remote_ids = tweets.map(&:tweet_id)
        LOGGER.info "Fetching remotes: #{remote_ids.inspect}"

        remotes = CLIENT.statuses(remote_ids)
        remotes.each do |remote|
          LOGGER.info remote.inspect

          tweet = Tweet.where(tweet_id: remote.id).take
          begin
            LOGGER.info "updating tweet with id #{tweet.tweet_id}"
            tweet.update(
              favorites: remote.favorite_count,
              retweets: remote.retweet_count
            )
          # Ugh, duplication
          rescue Twitter::Error::TooManyRequests => error
            sleep error.rate_limit.reset_in + 1
            retry
          end
        end
      rescue Twitter::Error::TooManyRequests => error
        sleep error.rate_limit.reset_in + 1
        retry
      end
    end
  end
end
