# frozen_string_literal: true

require 'find'
require 'securerandom'

# Populate the database with screenshots
module Populator
  MAX_PSQL_PARAMS = 65_535
  SCREENSHOT_PROPS = 5
  BLOCK_SIZE = (MAX_PSQL_PARAMS / SCREENSHOT_PROPS).floor

  def self.populate(path)
    abort "path doesn't exist (#{path})" unless Dir.exist?(path)
    records = glob_screenshots(path)
              .sort
              .map
              .with_index { |f, i| { path: f, order: i } }
    puts create_screenshots(records)
  end

  def self.glob_screenshots(path)
    Find.find(path)
        .select { |f| File.file?(f) }
        .select { |f| %w(.png .jpg).include? File.extname(f) }
  end

  def self.create_screenshots(records)
    rows = records.map do |r|
      [SecureRandom.uuid, r[:path], r[:order], Time.now, Time.now]
    end
    blocks = rows.each_slice(BLOCK_SIZE)
    blocks.each { |b| insert_screenshots(b) }
  end

  def self.insert_screenshots(block)
    slug = "insert-screenshots-#{SecureRandom.uuid}"
    conn = ActiveRecord::Base.connection.raw_connection

    statement = gen_query(block)
    conn.prepare(slug, statement)
    conn.exec_prepared(slug, block.flatten)
  end

  def self.gen_query(records)
    values = records.map.with_index do |_, i|
      first = (SCREENSHOT_PROPS * i) + 1
      marks = (first...(first + SCREENSHOT_PROPS)).map { |m| "$#{m}" }.join(',')
      "(#{marks})"
    end

    <<-SQL
      insert into screenshots(
        "id", "path", "order", "created_at", "updated_at"
      ) values #{values.join(',')}
    SQL
  end
end
