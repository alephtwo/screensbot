# screensbot

A CLI for screenshotting every second of a series of MKV videos and tweeting
them over a period of weeks.

## Requirements

* Postgres 9.6+
* Ruby 2.5+
* ffmpeg

## Configuration

Copy `database.yml.example` to `database.yml` and fill it out with your database
credentials. Then copy `twitter.yml.example` to `twitter.yml` and fill it out
with your Twitter API keys.

## Usage

```shell
$ bin/screensbot
Commands:
  screensbot eta              # Display the estimated time of completion for this batch
  screensbot finalize         # Gather metrics on all tweets in the database
  screensbot generate [path]  # Generate screenshots for a given path
  screensbot help [COMMAND]   # Describe available commands or one specific command
  screensbot populate         # Populate the database schema with screenshots
  screensbot tweet            # Post the next screenshot
  screensbot update-metrics   # Update the metrics of as many posts as possible
```

## Happy path

1. `bundle install`
1. Set up the config files.
1. `SCREENSBOT_ENV=production rake db:create db:migrate`
1. Gather your .mkv files.
1. Run `generate`, providing the folder as input.
1. Run `populate`, providing the `screenshots` folder as input.
1. Run `tweet` on a cron job.
1. Run `update-metrics` as frequently as desired, but less than `tweet`.
2. When it's all said and done, run `finalize` to run a final metrics pass.

## Development

Please run `rubocop` before sending any pull requests.
