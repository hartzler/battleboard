class MapLayer < RenderLayer
  def initialize
    @img = ImageLoader.load('hospice.png')
  end

  def render(g,width,height)
    g.drawImage(@img,0,0,nil)
  end 
end
