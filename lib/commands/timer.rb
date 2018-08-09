# frozen_string_literal: true

require_relative './tweeter'

# How long until it finishes?
module Timer
  POST_INTERVAL = 10 # minutes

  def self.eta
    t = Time.now + (minutes_remaining * 60)

    # Truncate the time to the nearest 10 minutes
    Time.at(t - (t.to_i % (10 * 60)))
  end

  def self.minutes_remaining
    remaining_posts.length * POST_INTERVAL
  end

  def self.remaining_posts
    Screenshot.left_joins(:tweet).where(tweets: { id: nil })
  end
end
