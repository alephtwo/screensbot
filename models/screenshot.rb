# frozen_string_literal: true

# Screenshot
class Screenshot < ActiveRecord::Base
  has_one :tweet
end
