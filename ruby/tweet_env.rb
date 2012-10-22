#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
Bundler.require

parser = ArgsParser.parse ARGV do
  arg :serialport, 'serial port', :alias => :port, :default => (
    fname = Dir.entries('/dev').grep(/tty\.usb/)[0]
    fname ? "/dev/#{fname}" : nil
  )
  arg :twitter, 'twitter user name'
  arg :tweet, 'do tweet', :default => false
  arg :help, 'show help', :alias => :h
end

if parser[:help] or !parser[:serialport]
  STDERR.puts parser.help
  STDERR.puts "e.g."
  STDERR.puts "  ruby #{$0} --twitter USERNAME --port /dev/tty.usb-device-name --tweet"
  exit 1
end

begin
  sp = SerialPort.new(parser[:serialport], 9600, 8, 1, 0)
rescue => e
  STDERR.puts e
  exit 1
end

loop do
  line = sp.gets.strip
  data = JSON.parse line rescue next
  next if !data['light'] or !data['temp']
  puts data.inspect
  if parser[:tweet]
    client = Tw::Client.new
    client.auth parser[:twitter]
    msg = {}
    msg['気温'] = data['temp']
    msg['明るさ'] = data['light']
    client.tweet msg.to_json
  end
  break
end
