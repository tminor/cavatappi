module Noodle::Web
  def self.app
    Rack::Builder.new do
      run Noodle::Web::Router.new
    end
  end
end
