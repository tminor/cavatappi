Noodle::Application.boot(:db) do
  init do
    require 'rom'
    require 'rom-repository'
    require 'rom-changeset'
    require 'sequel'

    connection = Sequel.connect(
      ENV['DATABASE_URL'],
      extensions: %i[pg_json],
      password: 'docker',
      user: 'postgres'
    )
    register('db.connection', connection)
    register(
      'db.config',
      ROM::Configuration.new(:sql, connection)
    )
  end
end
