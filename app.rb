# encoding: utf-8
#
#  PhotoView Web App.
#


require 'sinatra/base'
require 'haml'
require 'sass'
require 'json'

require './boot'
require './version'
require 'dirnode'
require 'thumbnail_pool'


class PhotoViewApp < Sinatra::Base

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  set :run, true

  enable :static
  set :public_folder, File.dirname(__FILE__) + "/static"
  enable :methodoverride
  enable :sessions


  # Root

  get '/' do
    @root = DirNode.read(PV_CONFIG["photo_dir"])
    @styles = %w( css/base )
    haml :index
  end

  # Style sheet

  get '/css/:style.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:style].intern
  end

  # Photo

  get '/photos/*' do
    send_file "#{PV_CONFIG["photo_dir"]}/#{params[:splat][0]}"
   end

  # Thumbnail

  get '/thumbnails/*' do
    pool = ThumbnailPool.new(PV_CONFIG["thumbnail_dir"], PV_CONFIG["photo_dir"])
    send_file pool.get(params[:splat][0])
  end

end
