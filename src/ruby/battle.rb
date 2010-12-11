#
# A battle is a map with levels, layers, and objects...
# it can be serialized out to disk as a json file.
# it belongs to a campaign
# battles reference resources (bitmaps) from the campaign
#
# add indexes as required...
#
class Battle
  
  attr_reader :campaign, :data, :logger
  def initialize(options)
    @campaign = options[:campaign] or raise "Campaign required"
    @images = {}
    @change_listeners = []
    @data = {}
    @data[:name] = options[:name] || "battle"
    @data[:info] = {} # battle meta info
    @data[:levels] = [] # {},{},{}... order by zorder; 
    @data[:objects] = {} # id => props
    @logger = Logger.getLogger("#{LOGGER_PREFIX}.#{self.class.name}")
  end

  def data
    @data.clone
  end

  def objects
    @data[:objects].clone
  end

  def info
    @data[:info].clone
  end

  def load_image(name)
    @images[name] ||= @campaign.load_image(name)
  end

  def save
    # filename is campaign.path + name

    # flush changesets
    # write new json
    # mv new -> old
    @campaign.save_battle_data(@data[:name],JSON.pretty_generate(@data))
  end

  def load
    logger.info "loading #{@data[:name]} ..."
    @data = JSON.parse(@campaign.load_battle_data(@data[:name])).symbolize_keys
    logger.info "loaded: #{data.inspect}"
    self
  end
  
  # add changeset
  # {:action=>:update,:path=>[:path,:to,:key],:value=>1}
  def change(change)
    change[:path] || raise(":path required for change")
    path = change[:path].map(&:to_sym)
    action = change[:action] || :update
    value = change[:value]
    logger.info "change recieved! :action=>#{action.inspect} :path=>#{path.inspect} :value=>#{value.inspect}"
    d = @data
    path[0..-2].each do |k|
      if d.has_key?(k)
        d = d[k]
      else
        raise "key #{k} in path #{path.inspect} not found!"
      end
    end
    case action
    when :update, :create
      d[path[-1]] = change[:value]
    when :delete
      d[path[-1]] = nil
    end
    @change_listeners.each{|l| l.change(self,changeset)} 
  end
  
  def add_change_listener(l)
    @change_listeners << l
  end

  def tokens
    objects.values.select{|o| o[:layer]=='token'}
  end
end
