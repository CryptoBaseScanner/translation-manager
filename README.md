# TranslationManager
Altrady app translations manager backend.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'translation_manager'
```
 
Create config/initializers/translation_manager.rb with languages list
```ruby
TranslationManager.setup do |config|
  config.languages = %i[es th kr]
end
```

Add mount to routes.rb
```ruby
mount TranslationManager::Engine => "/locales"
```