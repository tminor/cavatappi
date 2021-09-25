module Noodle
  module Persistence
    module Contracts
      module Hosts
        class Create < Dry::Validation::Contract
          params do
            required(:fqdn).filled(:string)
            required(:project).filled(:hash)
          end
        end
      end
    end
  end
end
