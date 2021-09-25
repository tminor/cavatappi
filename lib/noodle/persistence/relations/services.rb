require_relative 'relation'

module Noodle
  module Persistence
    module Relations
      class Services < Relation
        schema(:services, infer: true) do
          associations do
            belongs_to :project
          end
        end
      end
    end
  end
end
