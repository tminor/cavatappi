require_relative 'relation'

module Noodle
  module Persistence
    module Relations
      class Projects < Relation
        schema(:projects, infer: true) do
          associations do
            has_many :hosts
          end
        end
      end
    end
  end
end
