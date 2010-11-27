class OgreLayer < RenderLayer
  def initialize(width,height)
    @img = ImageLoader.load('ogre.png')
    @width = width
    @height = height
    @ogres = (1..20).map{|i| OpenStruct.new(:x=>rand(width),:y=>rand(height),:dx=>rand(20)+1,:dy=>rand(20)+1) }
  end
  
  def render(g)
    @ogres.each do |o|
      o.x += o.dx 
      o.y += o.dy 
      o.dx=-o.dx if o.x > width-20 || o.x < 0;
      o.dy=-o.dy if o.y > height-20 || o.y < 0;
      g.drawImage(@img,o.x,o.y,nil)
    end
  end
  
end
