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
      TokenLayer.new,
      LightLayer.new,
      BlockingLayer.new
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
      @tx -= (e.getX/@scale) - e.getX/(@scale+amt)
      @ty -= (e.getY/@scale) - e.getY/(@scale+amt)
      @scale += amt 
      redraw 
    end
  end

  def mousePressed(e)
    if command?(e)
      @sx=e.getX
      @sy=e.getY
    else
      global_x = e.getX/@scale - @tx
      global_y = e.getY/@scale - @ty

      # grab the first token under these coordinates
      token = @battle.tokens.detect do |o| 
        size = @battle.campaign.size_to_grid_squares(o[:size])
        (global_x > o.x && global_x < (o.x + size[0] * @battle.info.grid_ratio)) &&
          (global_y > o.y && global_y < (o.y + size[1] * @battle.info.grid_ratio))
      end
  
      # clear all other selections
      @battle.tokens.each{|t| @battle.change(:path=>[:objects,t[:id],:selected], :value=>false) if t.selected && (token ? t[:id]!=token[:id] : true)}

      # mark selected if needed
      @battle.change(:path=>[:objects,token[:id],:selected], :value=>true) if token && !token.selected
    end
    redraw
  end

  def mouseDragged(e)
    if command?(e)
      @tx += (e.getX - @sx)*(1.0/@scale)
      @ty += (e.getY - @sy)*(1.0/@scale)
      @sx = e.getX
      @sy = e.getY
      logger.info "dragged x: %d y: %d" % [@tx,@ty]
    else
      global_x = e.getX/@scale - @tx
      global_y = e.getY/@scale - @ty
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
