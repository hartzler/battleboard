#
# A battle is a map with levels, layers, and objects...
# it can be serialized out to disk as a json file.
# it belongs to a campaign
# battles reference resources (bitmaps) from the campaign
#
# add indexes as required...
#
class Battle
  attr_reader :campaign, :data
  def initialize(options)
    @campaign = options[:campaign] or raise "Campaign required"
    @images = {}
    @data = {}
    @data[:name] = options[:name] || "battle"
    @data[:info] = {} # battle meta info
    @data[:levels] = [] # {},{},{}... order by zorder; 
    @data[:objects] = {} # id => props
  end

  def objects
    @data[:objects]
  end

  def info
    @data[:info]
  end

  def load_image(name)
    @images[name] ||= @campaign.load_image(name)
  end

  def save
    # filename is campaign.path + name

    # flush changesets
    # write new json
    # mv new -> old
    @campaign.save_battle(@data[:name],JSON.generate(@data))
  end

  def load
    @data = JSON.parse(@campaign.load_battle(@data[:name]))
  end
  
  # add changeset
  def change(changeset)
    # create?/update/delete
  end

  def tokens
    objects.values.select{|o| o['layer']=='token'}
  end

end
