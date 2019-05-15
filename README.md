## Installation
Add this line to your application's Gemfile:

```ruby
gem 'admin', :git => 'git://github.com/VarlandMetalService/rails_admin'
```
then execute:
```bash
$ bundle install
```
then add this line to `routes.rb`
```ruby
mount Admin::Engine => "/admin"
```
