#
# Campaign is a directory with a settings file and a file for each battle
# it specifies resources and their locations (bitmaps)
#
# campaign/
#   resources/
#     resource_name1.png # can include / in name for namespacing/folder tree
#   settings.campaign
#   battle_name1.battle
#   battle_name2.battle
class Campaign
  DATA_FILE_NAME = 'data.campaign'
  BATTLE_EXT = '.battle'
  attr_reader :path, :resources, :data, :battles
  def initialize(options={})
    @battles = {}  # :name => Battle # nil unless "open"
    @resources = {} # key => value of name => path
    @data = {}
    @data[:settings] = {}
    load(options[:path]) if options[:path]
  end

  def settings
    @data[:settings]
  end

  def save
    save_data(DATA_FILE_NAME,JSON.pretty_generate(@data))
  end

  def load(path)
    @path = path
    @data = JSON.parse(load_data(DATA_FILE_NAME)).symbolize_keys
    load_resources
    load_battles
  rescue
    # no prob?
  end

  def battle(name)
    "Loading Battle #{name} ..."
    @battles[name] ||= Battle.new(:campaign=>self,:name=>name).load
  end

  def load_battles
    Dir.glob("#{@path}/*.#{BATTLE_EXT}") do |f|
      puts "Loading Battle #{f}"
      @battles[f.gsub(/^#{File.extname(f)}/,'')] = nil
    end
  end
  
  def load_resources
    puts "Loading Resources ..."
    Find.find("#{@path}/resources") do |f|
      unless FileTest.directory?(f)
        rf=f.to_s[("#{@path}/resources/}".size-1)..-1]
        #puts "Loading Resource #{rf} : #{rf[0..(-(File.extname(rf).size+1))]} => #{f}"
        @resources[rf[0..(-(File.extname(rf).size+1))]] = rf
      end
    end
    puts "Resources: #{@resources.inspect}"
  end  

  def load_image(name)
    puts "images/#{name} => #{@resources["images/#{name}"]}"
    ImageLoader.load(File.expand_path('resources' + File::SEPARATOR + @resources["images/#{name}"],@path)) 
  rescue 
    puts $!,$!.backtrace
    java.lang.System.exit(-1)
  end

  # copies into resources/ folder
  def add_resource(name,path)
    @resources[name]=path
  end

  def size_to_grid_squares(size)
    case size
    when 'large'
      [2,2]
    else
      raise "Unknow size #{size}"
    end
  end

  def load_battle_data(name)
    load_data(name+BATTLE_EXT)
  end
 
  def save_battle_data(name,data)
    save_data(name+BATTLE_EXT,data)
  end

protected
  def save_data(file,data)
    puts "Saving Data to #{File.expand_path(file, @path)} ..."
    a=File.expand_path(file, @path)
    open(a + '.tmp','w') {|f| f.write data}
    FileUtils.mv(a+'.tmp', a) 
  end

  def load_data(file)
    puts "Loading Data from #{file} in #{@path} ..."
    open(File.expand_path(file, @path), 'r') {|f| f.read}
  end
end

