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
local_require 'overrides'
local_require 'render_layer'
local_require 'background_layer'
local_require 'clear_layer'
local_require 'fps_layer'
local_require 'grid_layer'
local_require 'image_loader'
local_require 'token_layer'
local_require 'campaign'
local_require 'battle'
local_require 'battle_panel'
local_require 'battle_frame'

# main window
# constant for remote irb fun
java.lang.System.setProperty("com.apple.mrj.application.apple.menu.about.name", "BattleBoard!");
APP = BattleFrame.new
APP.show

# start IRB server
DRb.start_service 'druby://:7777', IRB::RemoteService.new
