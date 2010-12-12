class BattleFrame < JFrame
  attr_accessor :battle_panel, :battle_ui, :logger

  def initialize
    super('BattleBoard')
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    self.setIconImage(ImageLoader.load("icon.gif"))
    self.size = Dimension.new(800,600)
    self.content_pane.add(@battle_panel = BattlePanel.new)
    self.layered_pane.add(@battle_ui = BattleUI.new)
    logger.debug self.layered_pane.layout.inspect
  end

end
