class RoundedPanel < JPanel
  attr_accessor :logger
  def initialize(options={})
    super()
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
    @bgcolor = options[:color] || Color.new(0,0,0, 220)
    @outline_color = options[:outline_color] || Color::WHITE
    @stroke_size = options[:stroke_size] || 3.0
    self.opaque = false
    self.border = javax.swing.border.EmptyBorder.new(35,35,35,35)
  end

  def paintComponent(g) 
    x = 34;
    y = 34;
    w = width - 68;
    h = height - 68;
    arc = 30;

    g2 = g.create
    g2.setRenderingHint(java.awt.RenderingHints::KEY_ANTIALIASING,
            java.awt.RenderingHints::VALUE_ANTIALIAS_ON)

    g2.color = @bgcolor
    g2.fillRoundRect(x, y, w, h, arc, arc)


    g2.color = Color.new(0,0,0, 50)
    g2.stroke = java.awt.BasicStroke.new(6)
    g2.drawRoundRect(x+3, y+3, w, h, arc, arc)

    g2.color = @outline_color
    g2.stroke = java.awt.BasicStroke.new(@stroke_size)
    g2.drawRoundRect(x, y, w, h, arc, arc)

    g2.dispose
  end

end
