class FpsLayer < RenderLayer

  def initialize(report_interval)
    @report_interval = report_interval
    @font = Font.new("SansSerif", Font::PLAIN, 48);
    @fps = 0 
    @frame = 0
    @start = Time.now
  end

  def render(g)
    @frame += 1
    time = (Time.now-@start) 
    if time > @report_interval
      @fps = @frame / time
      @start = Time.now
      @frame = 0
    end
    t = g.get_transform
    g.scale(1.0/t.scale_x,1.0/t.scale_y)
    g.translate(-t.translate_x,-t.translate_y)
    g.color = Color::RED
    g.font = @font
    g.drawString("fps: %.1f scale: %.1f tx: %.1f" % [@fps,t.scale_x,t.translate_x],50,height-30)
  end

end
