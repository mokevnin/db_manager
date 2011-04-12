# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "db_manager/version"

Gem::Specification.new do |s|
  s.name        = "db_manager"
  s.version     = DbManager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mokevnin Kirill"]
  s.email       = ["mokevnin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Db manager}
  s.description = %q{Simple work with db: create, drop, load_schema etc}

  s.rubyforge_project = "db_manager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord', '>= 3.0.0')
end
