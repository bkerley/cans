$:.push File.expand_path("../lib", __FILE__)
require 'cans/version'

Gem::Specification.new do |s|
  s.name = %q{cans}
  s.version = Cans::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryce Kerley"]
  s.date = %q{2011-05-19}
  s.description = %q{Interactive on-line source browser for rack applications}
  s.email = %q{bkerley@brycekerley.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage = %q{http://github.com/bkerley/cans}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.9.2")
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Source browser for Rack applications}

  s.add_runtime_dependency(%q<sinatra>, ["~> 1.1.0"])
  s.add_runtime_dependency(%q<haml>, ["~> 3.0.22"])
  s.add_runtime_dependency(%q<method_extensions>, ["~> 0.0.8"])
  s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
  s.add_development_dependency(%q<rack-test>, ["~> 0.5.6"])
  s.add_development_dependency(%q<coffee-script>, ["~> 1.1.0"])
  s.add_development_dependency(%q<evergreen>, ["~> 0.4.0"])
  s.add_development_dependency(%q<mocha>, ["~> 0.9.12"])
end

