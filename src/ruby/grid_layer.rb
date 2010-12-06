class GridLayer < RenderLayer
  
  def render(g,width,height)
    if battle.info['grid_show']
      grid_ratio = battle.info['grid_ratio']
      g.color = Color::WHITE
      current_x = 0
      current_y = 0
      bg_size = battle.background_size
      battle.objects.values.select{|o| o['layer']=='background'}.each do |o|
        img = battle.load_image(o['image'])
        map_size_x = img.width
        map_size_y = img.height
        while current_x < map_size_x && current_y < map_size_y do
         start_x = battle.info['grid_offset_x'] + current_x
         start_y = battle.info['grid_offset_y'] + current_y
         g.drawLine(start_x, o.x, start_x, map_size_y)
         g.drawLine(o.y, start_y,  map_size_x, start_y)
         current_x += grid_ratio
         current_y += grid_ratio
       end
      end
    end
  end
  
end
