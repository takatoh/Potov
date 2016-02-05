# encoding: utf-8
#
#  Potov Web App.
#


require 'sinatra/base'
require 'haml'
require 'sass'
require 'json'

require './boot'
require './version'
require 'dir_node'
require 'thumbnail_pool'


class PotovApp < Sinatra::Base

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

  # Directory

  get '/dir/*' do
    @styles = %w( css/base )
    pool = ThumbnailPool.new(PV_CONFIG["thumbnail_dir"], PV_CONFIG["photo_dir"])
    dir = "#{PV_CONFIG["photo_dir"]}/#{params[:splat][0]}"
    @photos = Dir.glob("#{dir}/*").select do |f|
      photo?(f)
    end.map do |f|
      f = f.sub("#{PV_CONFIG["photo_dir"]}/", "")
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
    send_file "#{PV_CONFIG["photo_dir"]}/#{params[:splat][0]}"
   end

  # Thumbnail

  get '/thumbnail/*' do
    pool = ThumbnailPool.new(PV_CONFIG["thumbnail_dir"], PV_CONFIG["photo_dir"])
    send_file pool.get(params[:splat][0])
  end


  private

  def photo?(file)
    ext = File.extname(file).downcase
   File.file?(file) && %w( .png .jpg .jpeg .bmp .gif ).include?(ext)
  end

end
