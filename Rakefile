require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cans"
    gem.summary = %Q{Source browser for Rack applications}
    gem.description = %Q{Interactive on-line source browser for rack applications}
    gem.email = "bkerley@brycekerley.net"
    gem.homepage = "http://github.com/bkerley/cans"
    gem.authors = ["Bryce Kerley"]

    gem.add_dependency 'sinatra', '~> 1.1.0'
    gem.add_dependency 'haml', '~> 3.0.22'
    gem.add_dependency 'method_extensions', '~> 0.0.8'

    gem.add_development_dependency "shoulda", "~> 2.11.3"
    gem.add_development_dependency 'rack-test', '~> 0.5.6'
    gem.add_development_dependency 'coffee-script', '~> 1.1.0'
    gem.add_development_dependency 'evergreen', '~> 0.4.0'

    gem.required_ruby_version = '~> 1.9.2'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cans #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Compile the coffeescript files to javascript'
task :coffeescript => 'lib/cans/static/application.js'

file 'lib/cans/static/application.js' => 'lib/cans/views/application.coffee' do
  system 'coffee -co lib/cans/static lib/cans/views/application.coffee'
end
