include Java
java_import javax.swing.JPanel
java_import javax.swing.JFrame
java_import java.awt.Color
java_import java.awt.Font
java_import java.awt.Dimension
java_import java.awt.Toolkit
java_import java.awt.BorderLayout
java_import org.apache.log4j.Logger
java_import org.apache.log4j.Level
java_import java.awt.event.KeyEvent
java_import java.awt.event.KeyListener
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
local_require 'grid_layer'
local_require 'image_loader'
local_require 'token_layer'
local_require 'campaign'
local_require 'battle'
local_require 'battle_panel'
local_require 'battle_frame'
local_require 'battle_ui'
local_require 'rounded_panel'
local_require 'light_layer'
local_require 'blocking_layer'

# logging
LOGGER_PREFIX='bb'
logger=Logger.getLogger(LOGGER_PREFIX)
logger.add_appender org.apache.log4j.ConsoleAppender.new(org.apache.log4j.PatternLayout.new("[%d{ISO8601}][%-5p][%-25c] %m%n"))
logger.level=Level::DEBUG

# main window
# constant for remote irb fun
java.lang.System.setProperty("com.apple.mrj.application.apple.menu.about.name", "BattleBoard!");
APP = BattleFrame.new
APP.show

# start IRB server
DRb.start_service 'druby://:7777', IRB::RemoteService.new
