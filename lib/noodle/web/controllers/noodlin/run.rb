module Noodle
  module Web
    module Controllers
      module Noodlin
        class Run
          include Hanami::Action

          Noodle::Persistence::Entities.constants.each do |ent|
            include Noodle::Import["persistence.repositories.#{ent.downcase}_repository"]
          end

          def call(args)
          end
        end
      end
    end
  end
end
