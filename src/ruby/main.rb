include Java
java_import javax.swing.JPanel
java_import javax.swing.JFrame
java_import java.awt.Color
java_import java.awt.Font
java_import java.awt.Dimension
java_import java.awt.Toolkit
require 'ostruct'

def local_require(path)
  require File.expand_path( File.dirname(__FILE__) ) + '/' + path + '.rb'
end

local_require 'image_loader'
local_require 'render_layer'
local_require 'clear_layer'
local_require 'map_layer'
local_require 'ogre_layer'
local_require 'fps_layer'

class Game < JPanel
  include java.awt.event.MouseWheelListener
  include java.awt.event.MouseListener
  include java.awt.event.MouseMotionListener

  def initialize(w,h)
    super() # must call for add_component_listener to work
    @command_mask = java.lang.System.getProperty("os.name").downcase.index( "mac" ) ? 256 : 128
    @scale = 1.0
    @tx = 1
    @ty = 1
    @sx = 0
    @sy = 0
    @thack = false
    @layers = [ 
      ClearLayer.new,
      MapLayer.new,
      OgreLayer.new(w,h),
      FpsLayer.new(1)
    ]
    @layers.each{|l| add_component_listener(l)}
    add_mouse_wheel_listener(self)
    add_mouse_motion_listener(self)
    add_mouse_listener(self)
  end
 
  def paintComponent(g)
    g.scale(@scale,@scale)
    g.translate(@tx,@ty)
    @layers.each{|l| l.render(g) }
  end
  
  def mouseWheelMoved(e)
    amt = - e.wheel_rotation / 50.0
    if @scale + amt > 0.1 && @scale + amt < 10.0
      @tx += (@scale*e.x) - (@scale+amt)*e.x
      @ty += (@scale*e.y) - (@scale+amt)*e.y
      @scale += amt 
    end
  end

  def mousePressed(e)
    if command?(e)
      @sx=e.x
      @sy=e.y
    end
  end
  def mouseDragged(e)
    if command?(e)
      @tx += (e.x - @sx)*(1.0/@scale)
      @ty += (e.y - @sy)*(1.0/@scale)
      @sx = e.x
      @sy = e.y
      puts "dragged x: %d y: %d" % [@tx,@ty]
    end
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

app = JFrame.new('BattleBoard')
app.default_close_operation = JFrame::EXIT_ON_CLOSE
app.size = Dimension.new(800,600)
app.content_pane.add(game = Game.new(app.width,app.height))
app.show

while(true) do
  game.repaint
  sleep(0.001)
end

