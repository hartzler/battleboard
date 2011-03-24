class ClearLayer < RenderLayer
  def render(g,width,height)
    t = g.get_transform
    x = t.getScaleX
    y = t.getScaleY
    tx = t.translateX
    ty = t.translateY
    g.scale(1.0/x,1.0/y)
    g.translate(-tx,-ty)
    g.color = Color::BLACK
    g.fillRect(0,0,width,height)
    g.scale(x,y)
    g.translate(tx,ty)
  end
end
