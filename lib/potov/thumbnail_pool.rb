# encoding: utf-8


require 'pathname'
require 'fileutils'
require 'potov/photo_types'


module Potov
  class ThumbnailPool

    def initialize(thumbnail_dir, photo_dir)
      @dir = thumbnail_dir
      @photo_dir = photo_dir
    end

    # Get thumbnail path.
    def get(thumb_path)
      thumbnail = File.join(@dir, thumb_path)
      unless File.exist?(thumbnail)
        PhotoTypes::PHOTO_TYPES.each do |t|
          ext = File.extname(thumb_path)
          photo = File.join(@photo_dir, thumb_path.sub(ext, t))
          if File.exist?(photo)
            make(photo.sub("#{@photo_dir}/", ""))
            break
          end
        end
      end
      thumbnail
    end

    # Get thumbnail url path.
    def get_url_path(path)
      ext = File.extname(path)
      "/thumbnail/#{path.sub(ext, ".jpg")}"
    end

    # Make thumbnail.
    def make(path)
      photo_path = "#{@photo_dir}/#{path}"
      return nil unless PhotoTypes.photo?(photo_path)
      ext = File.extname(path)
      thumb_path = "#{@dir}/#{path.sub(ext, ".jpg")}"
      thumb = Pathname.new(thumb_path)
      unless thumb.exist?
        parent = thumb.parent
        parent.mkpath unless parent.exist?
        system("convert -scale 90x90 -flatten #{photo_path} #{thumb_path}")
        thumb_path.sub("#{@dir}/", "")
      else
        nil
      end
    end

    # Make thumbnail of photos in specified directory.
    def make_r(dir)
      thumbs = []
      if dir == @photo_dir
        dir = Pathname.new(@photo_dir)
      else
        dir = Pathname.new("#{@photo_dir}/#{dir}")
      end
      dir.find do |f|
        if f.file?
          thumbs << make(f.relative_path_from(Pathname.new(@photo_dir)).to_s)
        end
      end
      thumbs.compact
    end

    # Clean unused thumbnails.
    def clean
      thumbs = []
      Pathname.new(@photo_dir).find do |f|
        if f.file?
          ext = File.extname(f)
          thumbs << f.sub("#{@photo_dir}/", "").sub(ext, ".jpg")
        end
      end
      Pathname.new(@dir).find do |f|
        if f.file?
          f2 = f.sub("#{@dir}/", "")
          unless thumbs.include?(f2)
            puts f2
            FileUtils.rm(f)
          end
        end
      end
    end

  end   # of class ThumbnailPool
end   # of mudule Potov
