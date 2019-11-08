require 'potov/version'
require 'potov/dir_node'
require 'potov/thumbnail_pool'
require 'potov/photo_types'
require 'potov/app'


module Potov

  class << self
    attr_accessor :site_title, :photo_dir, :thumbnail_dir
  end

end   # of module Potov
