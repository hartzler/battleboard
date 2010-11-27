class MapLayer < RenderLayer
  def initialize
    @img = ImageLoader.load('hospice.png')
  end

  def render(g)
    g.drawImage(@img,0,0,nil)
  end 
end
