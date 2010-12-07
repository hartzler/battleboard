include Java
java_import javax.swing.JPanel
java_import javax.swing.JFrame
java_import java.awt.Color
java_import java.awt.Font
java_import java.awt.Dimension
java_import java.awt.Toolkit
require "rubygems"
require 'ostruct'
require 'json'
require 'fileutils'
require 'find'

def local_require(path)
  require File.expand_path( File.dirname(__FILE__) ) + '/' + path + '.rb'
end

local_require 'irb'
local_require 'render_layer'
local_require 'background_layer'
local_require 'clear_layer'
local_require 'fps_layer'
local_require 'grid_layer'
local_require 'image_loader'
local_require 'token_layer'
local_require 'campaign'
local_require 'battle'
local_require 'overrides'

class Game < JPanel
  include java.awt.event.MouseWheelListener
  include java.awt.event.MouseListener
  include java.awt.event.MouseMotionListener

  attr_reader :layers, :campaign, :battle

  def initialize(w,h)
    super() # must call for add_*_listener to work
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
      FpsLayer.new(1)
    ]
    @campaign = Campaign.new(:path=>'test/campaign1')
    @battle = @campaign.battle('battle1')
  
    # to update the test data...

    #@battle = Battle.new(:campaign=>@campaign,:name=>'battle1')
    #@battle.info['grid_ratio'] = 30
    #@battle.info['grid_show'] = true
    #@battle.info['grid_offset_x'] = 10
    #@battle.info['grid_offset_y'] = 10
    #@battle.objects['hospice'] = {'id' => 'hospice', 'image'=>'hospice', 'x'=>0, 'y'=>0, 'layer'=>'background'}
    #@battle.objects['ogre1'] = {'id' => 'ogre1', 'image'=>'ogre', 'x'=>100, 'y'=>100, 'layer'=>'token', 'size'=>'large'}
    #@battle.objects['ogre2'] = {'id' => 'ogre2', 'image'=>'ogre', 'x'=>300, 'y'=>500, 'layer'=>'token', 'size'=>'large'}

    #@campaign.save
    #@battle.save
 
    @layers.each{|l| l.campaign = @campaign; l.battle = @battle}
    add_mouse_wheel_listener(self)
    add_mouse_motion_listener(self)
    add_mouse_listener(self)
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
        size = @campaign.size_to_grid_squares(o[:size])
        (global_x > o.x && global_x < (o.x + size[0] * @battle.info.grid_ratio)) &&
          (global_y > o.y && global_y < (o.y + size[1] * @battle.info.grid_ratio))
      end.each{|o| o.selected = !o.selected}
    end
  end
  def mouseDragged(e)
    if command?(e)
      @tx += (e.x - @sx)*(1.0/@scale)
      @ty += (e.y - @sy)*(1.0/@scale)
      @sx = e.x
      @sy = e.y
      puts "dragged x: %d y: %d" % [@tx,@ty]
    else
      global_x = e.x/@scale - @tx
      global_y = e.y/@scale - @ty
      @battle.tokens.select(&:selected).each do |o| 
        o.x = global_x
        o.y = global_y
      end
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

# wrap in jframe for window/title
app = JFrame.new('BattleBoard')
app.default_close_operation = JFrame::EXIT_ON_CLOSE
app.size = Dimension.new(800,600)
app.content_pane.add(game = Game.new(app.width,app.height))
app.show

# for remote irb fun
APP = app
GAME = game

# start IRB server
DRb.start_service 'druby://:7777', IRB::RemoteService.new
STDERR.puts "* IRB::RemoteService available at #{DRb.uri.inspect}"

# main loop
while(true) do
  game.repaint
  sleep(0.001)
end

