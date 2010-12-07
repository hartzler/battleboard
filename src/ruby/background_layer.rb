class BackgroundLayer < RenderLayer
  def render(g,width,height)
    battle.objects.values.select{|o| o.layer=='background'}.each do |o|
      g.drawImage(battle.load_image(o.image),o.x,o.y,nil)
    end
  end 
end
