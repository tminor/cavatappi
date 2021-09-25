Noodle::Application.boot(:persistence) do |app|
  start do
    config = app['db.config']
    config.auto_registration(
      "#{app.root}/lib/noodle/persistence/",
      namespace: 'Noodle::Persistence'
    )

    register('container', ROM.container(app['db.config']))
  end
end
