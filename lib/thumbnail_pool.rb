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
    puts photo_path
    ext = File.extname(path)
    thumb_path = "#{@dir}/#{path.sub(ext, ".jpg")}"
    puts thumb_path
    parent = Pathname.new(thumb_path).parent
    parent.mkpath unless parent.exist?
    system("convert -scale 150x150 #{photo_path} #{thumb_path}")
    thumb_path.sub("#{@dir}/", "")
  end

  # Make thumbnail of photos in specified directory.
  def make_r(dir)
    dir = Pathname.new("#{@photo_dir}/#{dir}")
    dir.find do |f|
      if f.file?
        make(f.relative_path_from(Pathname.new(@photo_dir)).to_s)
      end
    end
  end

end   # of class ThumbnailPool
