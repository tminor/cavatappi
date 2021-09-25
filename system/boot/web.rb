require 'rack/handler/puma'

Noodle::Application.boot(:web) do |app|
  init do
    require 'hanami/api'
    require 'hanami/controller'
    require 'hanami/middleware/body_parser'
    require 'graphql'

    register('web.graphql', Noodle::Web::GraphQL)
  end

  start do
    config = app['web.graphql']
    config.auto_register(
      "#{app.root}/lib/noodle/web/graphql/",
      namespace: 'Noodle::Web::GraphQL'
    )
    Hanami::Controller.configure do
      handle_exceptions false
    end
  end
end
