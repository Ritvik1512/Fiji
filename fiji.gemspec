require './lib/fiji/version'

Gem::Specification.new do |s|
  s.name = %q{fiji}
  s.version = fiji::VERSION

  s.authors = ["Ritvik Choudhary"]
  s.description = %q{High performance memcached client for Ruby}
  s.email = %q{ritvik@outlook.com}
  s.files = Dir.glob("lib/**/*") + [
     "LICENSE",
     "README.md",,
     "Rakefile",
     "Gemfile",
     "fiji.gemspec",
  ]
  s.homepage = %q{http://github.com/Ritvik1512/fiji}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{High performance memcached client for Ruby}
  s.test_files = Dir.glob("test/**/*")
  s.add_development_dependency(%q<mini_shoulda>, [">= 0"])
  s.add_development_dependency(%q<mocha>, [">= 0"])
  s.add_development_dependency(%q<rails>, ["~> 3"])
end

