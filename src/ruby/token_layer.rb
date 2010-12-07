class TokenLayer < RenderLayer
  
  def render(g,width,height)
    battle.tokens.each do |o|
      grid_ratio = battle.info.grid_ratio
      size = campaign.size_to_grid_squares(o[:size])
      img = battle.load_image(o.image)
      g.drawImage(img,o.x,o.y, grid_ratio*size[0], grid_ratio*size[1],nil)
      if o.selected
        g.color = Color::RED
        g.drawRect(o.x, o.y, grid_ratio*size[0], grid_ratio*size[1])
      end
    end
  end
  
end
