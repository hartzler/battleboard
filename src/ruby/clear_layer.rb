class ClearLayer < RenderLayer
  def render(g)
    t = g.get_transform
    x = t.scale_x
    y = t.scale_y
    g.scale(1.0/x,1.0/y)
    g.color = Color::BLACK
    g.fillRect(0,0,width,height)
    g.scale(x,y)
  end
end
