require_relative 'repository'

module Noodle
  module Persistence
    module Repositories
      class ServiceRepository < Repository[:services]
        include Import[contract: 'persistence.contracts.services.create']
      end
    end
  end
end
