# encoding: utf-8
#
#  Potov Web App.
#


require 'sinatra/base'
require 'tilt/haml'
require 'tilt/sass'
require 'json'

#require './boot'
require 'potov/dir_node'
require 'potov/photo_types'
require 'potov/thumbnail_pool'


module Potov
  class App < Sinatra::Base

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
    end

    set :run, true

    enable :static
#    set :public_folder, File.dirname(__FILE__) + "/static"
    enable :methodoverride
    enable :sessions


    # Root

    get '/' do
      @root = DirNode.read(photo_dir)
      @styles = %w( css/base )
      haml :index
    end

    # Style sheet

    get '/css/:style.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass params[:style].intern
    end

    # Directory

    get '/dir/*' do
      @styles = %w( css/base )
      pool = ThumbnailPool.new(thumbnail_dir, photo_dir)
      dir = "#{photo_dir}/#{params[:splat][0]}"
      @photos = Dir.glob("#{dir}/*").select do |f|
        PhotoTypes.photo?(f)
      end.map do |f|
        f = f.sub("#{photo_dir}/", "")
        {
          "photo"     => "/photo/#{f}",
          "thumbnail" => pool.get_url_path(f),
          "filename"  => File.basename(f)
        }
      end.sort_by{|p| p["photo"]}
      haml :directory, layout: false
    end

    # Photo

    get '/photo/*' do
      send_file "#{photo_dir}/#{params[:splat][0]}"
     end

    # Thumbnail

    get '/thumbnail/*' do
      pool = ThumbnailPool.new(thumbnail_dir, photo_dir)
      send_file pool.get(params[:splat][0])
    end


    private

    def site_title
      Potov.site_title
    end

    def photo_dir
      Potov.photo_dir
    end

    def thumbnail_dir
      Potov.thumbnail_dir
    end

  end   # of class App
end   # of module Potov
