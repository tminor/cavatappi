module Noodle
  module Web
    module GraphQL
      module Types
        module BaseInterface
          include ::GraphQL::Schema::Interface

          field :name,
                String,
                'The unique name of a Noodle node',
                null: false
        end
      end
    end
  end
end
