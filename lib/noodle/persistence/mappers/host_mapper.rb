module Noodle
  module Persistence
    module Mappers
      class HostMapper < ROM::Transformer
        relation :hosts, as: :host_mapper

        map_array do
          symbolize_keys
          rename_keys name: :fqdn
        end
      end
    end
  end
end
