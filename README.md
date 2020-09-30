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
  config.google_translate_credentials = {
    type:                        "service_account",
    project_id:                  "cryptobasescanner",
    private_key_id:              "your private key id",
    private_key:                 "your private key",
    client_email:                "client email",
    client_id:                   "client id",
    auth_uri:                    "https://accounts.google.com/o/oauth2/auth",
    token_uri:                   "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url:        "x509 cert url"
  }
end
```

Add mount to routes.rb
```ruby
mount TranslationManager::Engine => "/locales"
```