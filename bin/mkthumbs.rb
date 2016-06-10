#!/usr/bin/env ruby
# encoding: utf-8


require 'optparse'
require './boot'
require './lib/thumbnail_pool'


options = {}
opts = OptionParser.new
opts.on("-c", "--clean", "Clean unused thumbnails."){|v| options[:clean] = true }
opts.on_tail("-h", "--help", "Show this message."){|v| puts opts; exit }
opts.parse!

dir = ARGV.shift || PV_CONFIG["photo_dir"]
pool = ThumbnailPool.new(PV_CONFIG["thumbnail_dir"], PV_CONFIG["photo_dir"])

if options[:clean]
  pool.clean
else
  pool.make_r(dir).each{|t| puts t }
end
