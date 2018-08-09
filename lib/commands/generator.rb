# frozen_string_literal: true

require 'find'

# Generate screenshots
module Generator
  def self.generate(path)
    abort "path doesn't exist (#{path})" unless Dir.exist? path
    Find.find(path) { |f| process_file(f) }
  end

  def self.process_file(path)
    return unless File.file? path
    return unless File.extname(path) == '.mkv'
    run_ffmpeg(path)
  end

  def self.run_ffmpeg(path)
    file = File.basename(path)
    target = File.join create_target_dir(path), '%04d.jpg'

    Dir.chdir(File.dirname(path)) do
      `ffmpeg -i '#{file}' -r 1 -vf "subtitles='#{file}'" '#{target}'`
    end
  end

  def self.create_target_dir(path)
    episode = File.basename(path, File.extname(path))
    target_dir = File.join(File.dirname(path), 'screenshots', episode)
    FileUtils.mkdir_p target_dir
    target_dir
  end
end
