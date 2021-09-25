module Noodle
  module Persistence
    module Changesets
      class CreateHostsRelation < ROM::Changeset::Create
        map do |tuple|
          @relation.schema.each_with_object(tuple) do |attr, obj|
            obj[attr.name] = obj[attr.alias] if attr.aliased?
          end
        end
      end
    end
  end
end
