class MapLayer < RenderLayer
  def render(g,width,height)
    battle.objects.each do |oid,o|
      g.drawImage(battle.load_image(o['image']),o['x'],o['y'],nil)
    end
  end 
end
