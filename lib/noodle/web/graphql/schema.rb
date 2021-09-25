module Noodle
  module Web
    module GraphQL
      class Schema < ::GraphQL::Schema
        lazy_resolve(Promise, :sync)

        query QueryType
      end
    end
  end
end
