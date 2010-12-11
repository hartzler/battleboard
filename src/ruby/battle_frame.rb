class BattleFrame < JFrame
  attr_accessor :battle_panel

  def initialize
    super('BattleBoard')
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    self.setIconImage(ImageLoader.load("icon.gif"))
    self.size = Dimension.new(800,600)
    self.content_pane.add(@battle_panel = BattlePanel.new)
  end
end
