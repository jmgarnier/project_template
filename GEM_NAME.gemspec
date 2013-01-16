$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "GEM_NAME"
require "#{name}/version"

Gem::Specification.new name, GEM_CLASS_NAME::VERSION do |gem|
  gem.summary = "GEM_DESCRIPTION"
  gem.authors = ["AUTHOR_NAME"]
  gem.email = "AUTHOR_EMAIL"
  gem.homepage = "http://github.com/AUTHOR_GITHUB/#{name}"
  gem.files         = %w(README.md) + Dir.glob("lib/**/*.rb")	
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.license = "MIT"
end
