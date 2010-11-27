include Java
java_import javax.swing.JPanel
java_import javax.swing.JFrame
java_import java.awt.Color
java_import java.awt.Font
java_import java.awt.Dimension
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

  def initialize(w,h)
    super() # must call for add_component_listener to work
    @scale = 1.0
    @layers = [ 
      ClearLayer.new,
      MapLayer.new,
      OgreLayer.new(w,h),
      FpsLayer.new(1)
    ]
    @layers.each{|l| add_component_listener(l)}
    add_mouse_wheel_listener(self)
  end
 
  def paintComponent(g)
    g.scale(@scale,@scale)
    @layers.each{|l| l.render(g) }
  end
  
  def mouseWheelMoved(e)
    amt = - e.wheel_rotation / 50.0
    @scale += amt if @scale + amt > 0.1 && @scale + amt < 10.0
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

