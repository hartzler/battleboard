require 'ant'

namespace :ivy do
  ivy_install_version = '2.2.0'
  ivy_jar_dir = './.ivy'
  ivy_jar_file = "#{ivy_jar_dir}/ivy.jar"

  task :download do
    mkdir_p ivy_jar_dir
    ant.get :src => "http://repo1.maven.org/maven2/org/apache/ivy/ivy/#{ivy_install_version}/ivy-#{ivy_install_version}.jar",
      :dest => ivy_jar_file,
      :usetimestamp => true
  end

  task :install => :download do
    ant.path :id => 'ivy.lib.path' do
      fileset :dir => ivy_jar_dir, :includes => '*.jar'
    end

    ant.taskdef :resource => "org/apache/ivy/ant/antlib.xml",
      #:uri => "antlib:org.apache.ivy.ant",
      :classpathref => "ivy.lib.path"
  end
end

def ivy_retrieve(org, mod, rev, conf)
  ant.retrieve :organisation => org,
    :module => mod,
    :revision => rev,
    :conf => conf,
    :pattern => 'javalib/[conf]/[artifact].[ext]',
    :inline => true
end

artifacts = %w[
  log4j log4j 1.2.16 default
]

task :download_deps => "ivy:install" do
  artifacts.each_slice(4) do |*artifact|
    ivy_retrieve(*artifact.first)
  end
end

task :default => :download_deps
