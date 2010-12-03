java_import javax.imageio.ImageIO

class ImageLoader
  def self.load(path)
    ImageIO.read(java.io.File.new(path))
  end
end
