module Noodle
  module Web
    module Controllers
      module GraphQL
        class Run
          include Hanami::Action

          Noodle::Persistence::Entities.constants.each do |ent|
            include Noodle::Import["persistence.repositories.#{ent.downcase}_repository"]
          end

          def call(params)
            variables = Hanami::Utils::Hash.stringify(params[:variables] || {})
          end
        end
      end
    end
  end
end
