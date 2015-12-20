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


class PhotoViewApp < Sinatra::Base

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  set :run, true

  enable :static
  set :public_dir, File.dirname(__FILE__) + "/public"
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

  #

  get '/thumbnails/*' do
  #   content_type "image/jpeg"
    send_file "#{PV_CONFIG["thumbnail_dir"]}/#{params[:splat][0]}"
  end

end
