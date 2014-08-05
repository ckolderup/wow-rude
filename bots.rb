#!/usr/bin/env ruby

require 'twitter_ebooks'

Ebooks::Bot.new("wow-rude") do |bot|
  bot.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  bot.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  bot.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  bot.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']

  bot.on_follow do |user|
    bot.follow(user[:screen_name])
  end

  bot.on_mention do |tweet, meta|
    prefix = meta[:reply_prefix].gsub(/@wowwwrude\s+/, '')
    bot.reply(tweet, prefix + "wow rude")
  end

  bot.on_timeline do |tweet, meta|
    if (rand(1..100) < 3) || tweet[:user][:screen_name] == 'ckolderup'
      prefix = meta[:reply_prefix].gsub(/@wowwwrude\s+/, '')
      bot.reply(tweet, prefix + "wow rude")
    end
  end
end
