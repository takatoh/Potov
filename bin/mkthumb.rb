#!/usr/bin/env ruby
# encoding: utf-8


require './boot'
require 'thumbnail_pool'


dir = ARGV.shift
pool = ThumbnailPool.new(PV_CONFIG["thumbnail_dir"], PV_CONFIG["photo_dir"])
pool.make_r(dir).each{|t| puts t }
