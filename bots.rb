#!/usr/bin/env ruby

require 'twitter_ebooks'

Ebooks::Bot.new("wow-rude") do |bot|
  bot.consumer_key = "" # Your app consumer key
  bot.consumer_secret = "" # Your app consumer secret
  bot.oauth_token = "" # Token connecting the app to this account
  bot.oauth_token_secret = "" # Secret connecting the app to this account

  bot.on_follow do |user|
    bot.follow(user[:screen_name])
  end

  bot.on_mention do |tweet, meta|
    bot.reply(tweet, meta[:reply_prefix] + "wow rude")
  end

  bot.on_timeline do |tweet, meta|
    if rand(1..100) < 3
      bot.reply(tweet, meta[:reply_prefix] + "wow rude")
    end
  end
end
