#
# Campaign is a directory with a settings file and a file for each battle
# it specifies resources and their locations (bitmaps)
#
# campaign/
#   resources/
#     resource_name1.png # can include / in name for namespacing/folder tree
#   settings.json
#   battle_name1.battle
#   battle_name2.battle
class Campaign
  attr_reader :path, :settings, :battles, :resources
  def initialize(options={})
    @battles = []  # names of the battle files
    @resources = {} # key => value of name => path
    @settings = {}
    load(options[:path]) if options[:path]
  end

  # write out settings
  def save
    # TODO: save
  end

  # load settings
  def load(path)
    # TODO: load
    @path = path
  end

  # copies into resources/ folder
  def add_resource(name,path)
    # TODO: copy into resources
    @resources[name]=path
  end

  def load_battle(name)
    open(File.expand_path(name + '.battle', @path, 'r')) {|f| f.read}
  end
 
  def save_battle(name,data)
    open(File.expand_path(name + '.battle', @path, 'w')) {|f| f.write data}
  end
end

