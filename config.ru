require_relative 'config/application'
require 'pry'

Noodle::Application.finalize!

Rack::Handler::Puma.run(
  Noodle::Web.app,
  Port: 8080
)
