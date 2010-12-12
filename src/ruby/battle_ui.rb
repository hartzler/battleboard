class BattleUI < JPanel
  def initialize(options={})
    super()
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
    @campaign = options[:campaign]
    self.opaque = false
    self.setBounds(20,20,220,120)
    self.layout = BorderLayout.new
    
    l = javax.swing.JLabel.new("BattleUI!")
    l.foreground = Color::WHITE
    p = RoundedPanel.new
    self.add(p,BorderLayout::CENTER)
    p.add(l)
  end
end
