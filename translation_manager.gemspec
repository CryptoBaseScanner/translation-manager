$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'translation_manager/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'translation_manager'
  spec.version     = TranslationManager::VERSION
  spec.authors     = ['Altrady']
  spec.email       = ['info@altrady.com']
  spec.homepage    = ''
  spec.summary     = 'Manage versioned translations.'
  spec.description = 'Allow the translations to be managed using a voting system. This can be integrated to allow users to make adjustments to the translations.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'google-cloud-translate'
  spec.add_dependency 'rails', '~> 6'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
