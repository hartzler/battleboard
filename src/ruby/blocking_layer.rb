class BlockingLayer < RenderLayer
  def initialize
    @fog = Color.new(0,0,0, 100)
  end

  def render(g, w, h)
    g.color = @fog
    g.fillRect(0,0,10000,10000)
 
    @battle.tokens.select(&:selected).each do |token|
      
    end
  end
end
