require_relative 'relation'

module Noodle
  module Persistence
    module Relations
      class Hosts < Relation
        schema(:hosts, infer: true) do
          attribute :name, Types::String.meta(alias: :fqdn), alias: :fqdn

          associations do
            many_to_one :projects, as: :project
          end
        end
      end
    end
  end
end
