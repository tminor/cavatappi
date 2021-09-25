module Noodle
  module Web
    module GraphQL
      class Runner
        def initialize(repositories:)
          @repositories = repositories
        end

        def run(query:, variables: {}, context: {})
          Web::GraphQL::Schema.execute(
            query,
            variables: variables,
            context: context
          )
        end
      end
    end
  end
end
