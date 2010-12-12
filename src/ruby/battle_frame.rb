class BattleFrame < JFrame
  include KeyListener
  include java.awt.event.WindowFocusListener
  attr_accessor :battle_panel, :battle_ui, :logger, :campaign

  def initialize
    super('BattleBoard')
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    self.setIconImage(ImageLoader.load("icon.gif"))
    self.size = Dimension.new(800,600)

    @campaign = Campaign.new(:path=>'test/campaign1')
    @campaign.select_battle('battle1')

    self.content_pane.add(@battle_panel = BattlePanel.new(:campaign=>@campaign))
    self.layered_pane.add(@battle_ui = BattleUI.new(:campaign=>@campaign))

    @battle_panel.addKeyListener(self)
    self.addWindowFocusListener(self)
  end

  def keyPressed(e) 
    @logger.debug("PRESSED: " + KeyEvent.key_text(e.key_code))
    case e.key_code 
    when KeyEvent::VK_SPACE
      @battle_ui.visible = !@battle_ui.visible? 
      @logger.debug("UI->visible: " + @battle_ui.visible?.to_s)
    end
  end

  def windowGainedFocus(e)
    @battle_panel.request_focus_in_window()
  end

  def windowLostFocus(e); end
  def keyTyped(e); end
  def keyReleased(e); end

end
