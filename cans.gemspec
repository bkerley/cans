# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cans}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryce Kerley"]
  s.date = %q{2010-11-12}
  s.description = %q{Interactive on-line source browser for rack applications}
  s.email = %q{bkerley@brycekerley.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "cans.gemspec",
     "config.ru",
     "lib/cans.rb",
     "lib/cans/address.rb",
     "lib/cans/application.rb",
     "lib/cans/historian.rb",
     "lib/cans/views/index.haml",
     "lib/cans/views/method.haml",
     "lib/cans/views/module.haml",
     "test/fixtures/beverage.rb",
     "test/helper.rb",
     "test/test_address.rb",
     "test/test_application.rb",
     "test/test_cans.rb",
     "test/test_historian.rb"
  ]
  s.homepage = %q{http://github.com/bkerley/cans}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.9.2")
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Source browser for Rack applications}
  s.test_files = [
    "test/fixtures/beverage.rb",
     "test/helper.rb",
     "test/test_address.rb",
     "test/test_application.rb",
     "test/test_cans.rb",
     "test/test_historian.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<haml>, ["~> 3.0.22"])
      s.add_runtime_dependency(%q<method_extensions>, ["~> 0.0.8"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.5.6"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.9"])
    else
      s.add_dependency(%q<sinatra>, ["~> 1.1.0"])
      s.add_dependency(%q<haml>, ["~> 3.0.22"])
      s.add_dependency(%q<method_extensions>, ["~> 0.0.8"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_dependency(%q<rack-test>, ["~> 0.5.6"])
      s.add_dependency(%q<mocha>, ["~> 0.9.9"])
    end
  else
    s.add_dependency(%q<sinatra>, ["~> 1.1.0"])
    s.add_dependency(%q<haml>, ["~> 3.0.22"])
    s.add_dependency(%q<method_extensions>, ["~> 0.0.8"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
    s.add_dependency(%q<rack-test>, ["~> 0.5.6"])
    s.add_dependency(%q<mocha>, ["~> 0.9.9"])
  end
end

