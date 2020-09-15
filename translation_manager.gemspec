$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "translation_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "translation_manager"
  spec.version     = TranslationManager::VERSION
  spec.authors     = ["Artur Komarov"]
  spec.email       = ["artur.komarov@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of TranslationManager."
  spec.description = "Description of TranslationManager."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.2"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
end
