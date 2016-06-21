# encoding: utf-8


module PhotoTypes

  PHOTO_TYPES = %w( .png .jpg .jpeg .bmp .gif )


  def photo?(file)
    ext = File.extname(file).downcase
    File.file?(file) && PHOTO_TYPES.include?(ext)
  end

  module_function :photo?

end   # of module PhotoTypes
