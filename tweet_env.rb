#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
Bundler.require

parser = ArgsParser.parse ARGV do
  arg :arduino, 'arduino serial port', :default => ArduinoFirmata.list[0]
  arg :tweet, 'twitter user name'
  arg :help, 'show help', :alias => :h
end

if parser[:help] or !parser[:arduino]
  STDERR.puts parser.help
  STDERR.puts "e.g."
  STDERR.puts "  ruby #{$0} --tweet USERNAME --port /dev/tty.usb-device-name"
  exit 1
end

arduino = ArduinoFirmata.connect parser[:arduino]

light = arduino.analog_read 0
puts "明るさ #{light}"
temp = arduino.analog_read(1).to_f*5*100/1024
puts "温度 #{temp}"

if parser.has_param? :tweet
  client = Tw::Client.new
  client.auth parser[:tweet]
  msg = {}
  msg['気温'] = temp
  msg['明るさ'] = light
  client.tweet msg.to_json
end
