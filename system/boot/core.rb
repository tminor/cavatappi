Noodle::Application.boot(:core) do
  init do
    require 'dry-validation'
    require 'dry/monads'
    require 'dry/monads/do'
    require 'noodle/types'
    require 'rom/transformer'

    start do
      Dry::Validation.load_extensions(:monads)
    end
  end
end
