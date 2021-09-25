require_relative 'repository'

module Noodle
  module Persistence
    module Repositories
      class HostRepository < Repository[:hosts]
        include Import[contract: 'persistence.contracts.hosts.create']

        def stage(params)
          Success(
            hosts.changeset(
              Changesets::CreateHostsRelation,
              params
            ).map(:add_timestamps)
          )
        end
      end
    end
  end
end
