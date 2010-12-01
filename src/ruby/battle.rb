#
# A battle is a map with levels, layers, and objects...
# it can be serialized out to disk as a json file.
# it belongs to a campaign
# battles reference resources (bitmaps) from the campaign
#
# add indexes as required...
#
class Battle
  attr_reader :campaign, :name, :info, :levels, :objects
  def initialize(options)
    @campaign = options[:campaign] or raise "Campaign required"
    @name = options[:name] || "battle"
    @info = {} # battle meta info
    @levels = [] # {},{},{}... order by zorder; 
    @objects = {} # id => props
  end

  def save
    # filename is campaign.path + name

    # flush changesets
    # write new json
    # mv new -> old
  end

  def load
    # load name.battle
  end
  
  # add changeset
  def change(changeset)
    # create?/update/delete
  end

end
