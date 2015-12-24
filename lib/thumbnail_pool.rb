# encoding: utf-8


require 'pathname'


class ThumbnailPool

  PHOTO_TYPES = %w( .png .bmp .jpg .jpeg .gif .tif .tiff )

  def initialize(thumbnail_dir, photo_dir)
    @dir = thumbnail_dir
    @photo_dir = photo_dir
  end

  # Get thumbnail path.
  def get(path)
    ext = File.extname(path)
    path2 = path.sub(ext, ".jpg")
    "#{@dir}/#{path2}"
  end

  # Get thumbnail url path.
  def get_url_path(path)
    ext = File.extname(path)
    "/thumbnail/#{path.sub(ext, ".jpg")}"
  end

  # Make thumbnail.
  def make(path)
    photo_path = "#{@photo_dir}/#{path}"
    ext = File.extname(path)
    return nil unless PHOTO_TYPES.include?(ext)
    thumb_path = "#{@dir}/#{path.sub(ext, ".jpg")}"
    thumb = Pathname.new(thumb_path)
    unless thumb.exist?
      parent = thumb.parent
      parent.mkpath unless parent.exist?
      system("convert -scale 150x150 #{photo_path} #{thumb_path}")
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

end   # of class ThumbnailPool
