# frozen_string_literal: true

require 'twitter'
require 'retryable'
require 'set'

# Unabashedly stolen from github.com/sferik/t, which is super awesome
module Collectable
  MAX_NUM_RESULTS = 200
  MAX_PAGE = 51

  def self.collect_with_max_id(collection = [], max_id = nil, &block)
    tweets = Retryable.retryable(tries: 3, on: Twitter::Error, sleep: 0) do
      yield(max_id)
    end
    return collection if tweets.nil?
    collection += tweets
    if tweets.empty?
      collection.flatten
    else
      collect_with_max_id(collection, tweets.last.id - 1, &block)
    end
  end

  def self.collect_with_count(count)
    opts = {}
    opts[:count] = MAX_NUM_RESULTS
    collect_with_max_id do |max_id|
      opts[:max_id] = max_id unless max_id.nil?
      opts[:count] = count unless count >= MAX_NUM_RESULTS
      if count.positive?
        tweets = yield opts
        count -= tweets.length
        tweets
      end
    end.flatten.compact
  end
end
