require_relative 'repository'

module Noodle
  module Persistence
    module Repositories
      class ProjectRepository < Repository[:projects]
        include Import[contract: 'persistence.contracts.projects.create']
      end
    end
  end
end
