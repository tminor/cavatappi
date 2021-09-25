module Noodle
  module Web
    module GraphQL
      module Types
        module Node
          include BaseInterface

          field :project,
                Project,
                'The Noodle project to which this node belongs',
                null: true
        end
      end
    end
  end
end
