class BattlePanel < JPanel
  include java.awt.event.MouseWheelListener
  include java.awt.event.MouseListener
  include java.awt.event.MouseMotionListener

  attr_reader :layers, :campaign, :battle, :logger

  def initialize(options={})
    super() # must call for add_*_listener to work
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
    @command_mask = java.lang.System.getProperty("os.name").downcase.index( "mac" ) ? 256 : 128
    @scale = 1.0
    @tx = 0
    @ty = 0
    @sx = 0
    @sy = 0
    @layers = [ 
      ClearLayer.new,
      BackgroundLayer.new,
      GridLayer.new,
      TokenLayer.new
    ]
    self.campaign=options[:campaign]
    add_mouse_wheel_listener(self)
    add_mouse_motion_listener(self)
    add_mouse_listener(self)
  end

  def campaign=(c)
    @campaign = c
    @battle = @campaign.selected_battle
    @campaign.add_selected_battle_listener(self)
    @layers.each{|l| l.campaign = @campaign; l.battle = @battle}
  end

  def selected_battle_changed(c,b)
    self.campaign = c
  end
  
  def paintComponent(g)
    g.translate(@tx,@ty)
    g.scale(@scale,@scale)
    @layers.each{|l| l.render(g,width,height) }
  end
  
  def mouseWheelMoved(e)
    amt = - e.wheel_rotation / 50.0
    if @scale + amt > 0.1 && @scale + amt < 10.0
      @tx -= (e.x/@scale) - e.x/(@scale+amt)
      @ty -= (e.y/@scale) - e.y/(@scale+amt)
      @scale += amt 
      redraw 
    end
  end

  def mousePressed(e)
    if command?(e)
      @sx=e.x
      @sy=e.y
    else
      global_x = e.x/@scale - @tx
      global_y = e.y/@scale - @ty
      @battle.tokens.select do |o| 
        size = @battle.campaign.size_to_grid_squares(o[:size])
        (global_x > o.x && global_x < (o.x + size[0] * @battle.info.grid_ratio)) &&
          (global_y > o.y && global_y < (o.y + size[1] * @battle.info.grid_ratio))
      end.each{|o| @battle.change(:path=>[:objects,o[:id],:selected], :value=>!o.selected)}
    end
    redraw
  end

  def mouseDragged(e)
    if command?(e)
      @tx += (e.x - @sx)*(1.0/@scale)
      @ty += (e.y - @sy)*(1.0/@scale)
      @sx = e.x
      @sy = e.y
      logger.info "dragged x: %d y: %d" % [@tx,@ty]
    else
      global_x = e.x/@scale - @tx
      global_y = e.y/@scale - @ty
      @battle.tokens.select(&:selected).each do |o| 
        @battle.change(:path=>[:objects,o[:id],:x],:value=>global_x)
        @battle.change(:path=>[:objects,o[:id],:y],:value=>global_y)
      end
    end
    redraw
  end
  
  def redraw
    parent.parent.repaint
  end

  def mouseMoved(e); end
  def mouseClicked(e); end
  def mouseEntered(e); end
  def mouseReleased(e); end
  def mouseExited(e); end
 
  def command?(e)
    (e.modifiers_ex & @command_mask) == @command_mask
  end

end
