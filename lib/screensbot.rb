# frozen_string_literal: true

require 'logger'
require 'thor'
require_relative 'initializers/initialize'
require_relative 'commands/generator'
require_relative 'commands/gatherer'
require_relative 'commands/populator'
require_relative 'commands/tweeter'
require_relative 'commands/timer'
require_relative 'commands/finalizer'

# Command Line Tool
class Screensbot < Thor
  desc 'tweet', 'Post the next screenshot'
  def tweet
    Tweeter.tweet
  end

  desc 'generate [path]', 'Generate screenshots for a given path'
  def generate(path)
    Generator.generate(path)
  end

  desc 'populate', 'Populate the database schema with screenshots'
  def populate(path)
    Populator.populate(path)
  end

  desc 'update-metrics', 'Update the metrics of as many posts as possible'
  def update_metrics
    Gatherer.update_metrics
  end

  desc 'eta', 'Display the estimated time of completion for this batch'
  def eta
    puts Timer.eta.strftime '%B %-d %Y %H:%M:%S'
  end

  desc 'finalize', 'Gather metrics on all tweets in the database'
  def finalize
    Finalizer.finalize
  end
end
