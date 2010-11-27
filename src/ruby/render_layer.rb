class RenderLayer
  include java.awt.event.ComponentListener
  attr_reader :width, :height
  def componentResized(e)
    @width = e.component.width
    @height = e.component.height
  end
end
