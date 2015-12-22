# encoding: utf-8


require 'pathname'


class ThumbnailPool

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

  # Make thumbnail.
  def make(path)
    photo_path = "#{@photo_dir}/#{path}"
    ext = File.extname(path)
    thumb_path = "#{@dir}/#{path.sub(ext, ".jpg")}"
    system("convert #{photo_path} #{thumb_path}")
    thumb_path.sub("#{@dir}/", "")
  end

  # Make thumbnail of photos in specified directory.
  def make_r(dir)
    dir = Pathname.new(dir)
    dir.find do |f|
      make(f.relative_path_from(Pathname.new(dir).to_s) if f.file?
    end
  end

end   # of class ThumbnailPool
