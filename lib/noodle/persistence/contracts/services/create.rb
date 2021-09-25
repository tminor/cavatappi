module Noodle
  module Persistence
    module Contracts
      module Services
        class Create < Dry::Validation::Contract
          params do
            required(:name).filled(:string)
          end
        end
      end
    end
  end
end
