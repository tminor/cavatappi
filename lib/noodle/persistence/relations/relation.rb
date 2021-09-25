module Noodle
  module Persistence
    module Relations
      class Relation < ROM::Relation[:sql]
        schema {}

        def where(*args, &block)
          args.each do |a|
            rename_aliased_attrs(a)
            get_associations(a).each { |attr| a.delete(attr) }
          end

          super
        end

        def fetch(id)
          by_pk(id).combine(schema.associations.to_h.keys).one
        end

        def rename_aliased_attrs(params)
          schema.attributes.each_with_object(params) do |attr, obj|
            next unless attr.aliased?

            obj[attr.name] = obj[attr.alias] && obj.delete(attr.alias)
          end
        end

        def get_associations(params)
          schema.associations.to_h.keys.select { |a| params.keys.member? a }
        end
      end
    end
  end
end
