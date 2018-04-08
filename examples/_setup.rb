require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'eureka-bot'
require_relative "../lib/eureka_bot/tg"

$tg_token = nil

path = File.dirname(__FILE__) + '/_tg.txt'

if File.exists?(path)
  $tg_token = File.read(path).strip
else
  raise 'Please create examples/_tg.txt file with Telegram bot token.'
end

EurekaBot.logger     = Logger.new(STDOUT)
EurekaBot::Tg.client = EurekaBot::Tg::Client.new(token: $tg_token)