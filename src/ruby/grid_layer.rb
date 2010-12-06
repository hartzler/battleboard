class GridLayer < RenderLayer
  
  def render(g,width,height)
    if battle.info['grid_show']
      grid_ratio = battle.info['grid_ratio']
      g.color = Color::WHITE
      current_x = 0
      current_y = 0
      bg_size = battle.background_size
      while current_x < bg_size[0] && current_y < bg_size[1] do
        start_x = battle.info['grid_offset_x'] + current_x
        start_y = battle.info['grid_offset_y'] + current_y
        g.drawLine(start_x, 0, start_x, bg_size[1])
        g.drawLine(0, start_y, bg_size[0], start_y)
        current_x += grid_ratio
        current_y += grid_ratio
      end
    end
  end
  
end
