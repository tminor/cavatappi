module Noodle
  module Persistence
    module Contracts
      module Projects
        class Create < Dry::Validation::Contract
          params do
            required(:name).filled(:string)
            optional(:hosts).filled(:array)
          end
        end
      end
    end
  end
end
