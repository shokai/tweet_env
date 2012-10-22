#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
Bundler.require

portname = ARGV.shift

begin
  sp = SerialPort.new(portname, 9600, 8, 1, 0)
rescue => e
  STDERR.puts e
  exit 1
end

client = Tw::Client.new
client.auth 'shokai_log'

loop do
  line = sp.gets.strip
  data = JSON.parse line rescue next
  next if !data['light'] or !data['temp']
  puts data.inspect
  client.tweet data.to_json
  break
end
