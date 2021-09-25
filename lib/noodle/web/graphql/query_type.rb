module Noodle
  module Web
    module GraphQL
      class QueryType < ::GraphQL::Schema::Object
        graphql_name 'Query'
        description  'The query root of this schema'

        field :nodes, [GraphQL::Types::Node], null: true do
          # arguments
        end
      end
    end
  end
end
