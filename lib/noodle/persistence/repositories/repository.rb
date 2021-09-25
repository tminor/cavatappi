module Noodle
  module Persistence
    module Repositories
      class Repository < ROM::Repository::Root
        include Dry::Monads[:result]
        include Dry::Monads[:try]
        include Dry::Monads::Do.for(:add)

        include Import['container']

        struct_namespace Noodle

        def initialize(**args)
          super

          self.class.send(:alias_method, :project, :projects)
        end

        # @return [Array<Noodle::Node>]
        #
        def all
          root.to_a
        end

        # @param params [Hash] search parameters
        # @return [Noodle::Node] a Noodle node
        #
        def find(params)
          root.where(params)
        end

        # @param par [TYPES] DESCRIPTION
        def combined_find(params)
          root.where(params).combine(root.associations.to_h.keys)
        end

        def create(params)
          result = add(params)

          case result
              in Success[:created, node]
              Success(root.fetch(node.id))
              in Failure[:node_not_unique, *]
              Failure[:node_exists, combined_find(params)]
              in Failure(_)
              result
          end
        end

        def add(params)
          transaction do
            values = yield validate(params)
            staged = yield stage(values.to_h)
            node   = yield make_associations(params, staged)

            persist(node)
          end
        end

        def validate(params)
          Success(contract.call(params))
        end

        def stage(params)
          result = Try { root.changeset(:create, params).map(:add_timestamps) }

          result.value? ? Success(result.value!) : Failure[:staging_failed, result.exception]
        end

        def persist(staged)
          result = Try[ROM::SQL::UniqueConstraintError] { staged.commit }

          result.value? ? Success[:created, result.value!] : Failure[:node_not_unique, result.exception]
        end

        def associate(params, staged)
          errs = []
          root.get_associations(params).each do |association|
            err = Failure[:"nonexistent_#{association}"]
            other = send(association).where(params[association]).one
            staged = other.nil? ? errs << err : staged.associate(other)
          end

          [staged, errs]
        end

        def make_associations(params, staged)
          result, errs = associate(params, staged)

          return Success(result) if errs.empty?

          Failure[:association_failed, result.select(&:failure?)]
        end
      end
    end
  end
end
