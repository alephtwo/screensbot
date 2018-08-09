# frozen_string_literal: true

# Tweet
class Tweet < ActiveRecord::Base
  belongs_to :screenshot
end
