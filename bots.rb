#!/usr/bin/env ruby

require 'twitter_ebooks'

Ebooks::Bot.new("wowwwrude") do |bot|
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
    rolled_high = rand(1..100) >= 95
    follows_me = bot.twitter.friendship?(tweet[:user][:screen_name], 'wowwwrude')

    # skip actual and manual RTs
    next if tweet[:retweeted_status] || tweet[:text].start_with?('RT')

    # skip ebook bots
    next if tweet[:user][:screen_name].downcase.end_with('_ebooks')

    if rolled_high
      if follows_me
        bot.reply(tweet, "@#{tweet[:user][:screen_name]} wow rude")
      else
        puts "rolled high but #{tweet[:user][:screen_name]} doesn't follow me"
      end
    end
  end

  bot.scheduler.every '1h' do
    ### Check for follow/unfollow to-dos on schedule:
    followers = bot.twitter.followers.map { |x| x[:screen_name] }
    following = bot.twitter.following.map { |x| x[:screen_name] }
    to_follow = followers - following
    to_unfollow = following - followers
    bot.twitter.follow(to_follow) unless to_follow.empty?
    bot.twitter.unfollow(to_unfollow) unless to_unfollow.empty?
    following -= to_unfollow
    puts "Followed #{to_follow.size}; unfollowed #{to_unfollow.size}."
  end 
end
