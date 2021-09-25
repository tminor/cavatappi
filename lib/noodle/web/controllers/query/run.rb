module Noodle
  module Web
    module Controllers
      module Query
        class Run
          include Hanami::Action

          Noodle::Persistence::Entities.constants.each do |ent|
            include Noodle::Import["persistence.repositories.#{ent.downcase}_repository"]
          end

          def call(params)
          end

          private

          def self.magic(query)
            search          = Noodle::Search.new(Noodle::NodeRepository.repository)
            show            = []
            format          = :default
            # merge           = false
            hostnames       = []
            thing2unique    = nil

            # NOTE: Order below must be preserved in case statement.
            bareword_hash               = Noodle::Option.class_variable_get(:@@bareword_hash)
            # TODO: Perhaps processing ? and ?= should happen in the same
            # block of code. This would/could allow for ?+ to work too. And
            # even permutations like =?
            term_present_and_show_value = Regexp.new '\?=$|=\?$'     # Matches when term ends in ?= or =?
            term_present                = Regexp.new '^[^@=]+\?$'    # Matches when term does not contain = and ends in ?
            term_does_not_equal         = Regexp.new '^[-@][^=]+=.+' # Matches when term starts with - or @ and contains X=Y
            term_not_present            = Regexp.new '^[-@][^=]+'
            # Order really matters for the rest of these:
            term_show_value             = Regexp.new '=$'            # Matches when terms ends with =
            term_matches_regexp         = Regexp.new '=~'            # Matches when term contais =~
            term_equals                 = Regexp.new '='             # Matches when term contains =; order matters for this
            term_unique_values          = Regexp.new '^:'            # Matches when term starts with :
            term_sum                    = Regexp.new '[+]$'          # Matches when term ends with +

            # TODO: The required ordering below is ugly which indicates
            # there's a better way.
            query.split(/\s+/).each do |part|
              case part
              when *bareword_hash.keys
                format = :list
                value = part
                term = bareword_hash[value]
                search.equals(term, value)

              # Look for this before term_persent since term_present matches both
              when term_present_and_show_value
                format = :list
                term = part.sub(term_present_and_show_value, '')
                search.exists(term)
                show << term

              when term_does_not_equal
                format = :list
                term, value = part.sub(/^[-@]/, '').split(/=/, 2)
                search.not_equal(term, value)

              # Look for this after term_does_not_equal since it this regexp matches. TODO: Ugly!
              when term_not_present
                format = :list
                term = part.sub(/^[-@]/, '')
                search.does_not_exist(term)

              when term_present
                format = :list
                term = part.sub(/\?$/, '')
                          search.exists(term)

                        when term_show_value
                          format = :list
                          show << part.chop

                        when term_matches_regexp
                          format = :list
                          term, value = part.split(term_matches_regexp, 2)
                          search.match_regexp(term, value)

                        when term_equals
                          format = :list
                          term, value = part.split(term_equals, 2)
                          search.equals(term, value)

                        when term_unique_values
                          thing2unique = part.sub(term_unique_values, '')
                          format = :unique_values

                        when term_sum
                          format = :sum
                          term = part.sub(term_sum, '')
                          search.sum(term)

                        when 'full'
                          format = :full

                        when 'json'
                          format = :json

                        when 'json_params_only'
                          format = :json_params_only

                        # TODO: What use cas was merge intended for? The search code had this:
                        # found = merge(found,hostnames,show) if merge
                        #
                        # when 'merge'
                        #   merge = true

                        else
                          # Assume everything else is a hostname (or partial hostname)
                          # TODO: Maybe this is a bit awkward when bare words are used with
                          # other magic operators?
                          hostnames.push(part)
                          search.match_names(part)
                        end
                      end

                      # Use default ilk and status unless they are specified in the query:
                      search.equals('ilk', Noodle::Option.option('default', 'default_ilk')) unless search.search_terms.include?('ilk')
                      search.equals('status', Noodle::Option.option('default', 'default_status')) unless search.search_terms.include?('status')

                      # Assume the best
                      status = 200

                      # Let's rethink this.
                      # There are just a few different cases. Listed in order of precedence:
                      case format

                      # 1. Unique is simply its own thing
                      when :unique_values
                        body = Noodle::Search.new(Noodle::NodeRepository.repository).param_values(term: thing2unique, facts: true).sort.join("\n") + "\n"

                      # 2 Sum is also its own thing; as-is it overrides prodlevel= and similar
                      when :sum
                        body = []
                        found = search.go
                        found.response.aggregations.each do |param, sum|
                          body << "#{param}=#{sum.value}"
                        end
                        body = body.join(' ')

                      # 3. json and full in which we want *everything* returned with different output formats
                      when :json
                        search.limit_fetch(show)
                        found = search.go
                        body = found.results.to_json + "\n"
                      when :full
                        found = search.go
                        body = found.results.map(&:full).join("\n") + "\n"

                      # 4. json_params_only and yaml (AKA "puppet") in which we only want params returned (:json_params_only, :yaml)
                      when :json_params_only
                        found = search.go(name_and_params_only: true)
                        # TODO: What's the pretty/correct way to do this?
                        found.results.each do |result|
                          result.facts = {}
                        end
                        body = found.results.to_json
                      # 5. Everything else except for YAML, in which we only want hostnames *OR* hostnames plus specific fields
                      when :list
                        # Limit the search results to the fields we are supposed to display (if any)
                        search.limit_fetch(show)
                        # If no fields to show, limit the search results to node names
                        found = search.go(names_only: show.empty?)

                        ['', 200] if found.response.hits.empty?
                        # Always show name. Show term=value pairs for anything in 'show'
                        body = []
                        shown = []
                        found.results.each do |hit|
                          add = hit.name
                          show.each do |term|
                            # Ahem, this funtimes "send" party lets you extract deep
                            # values from hashes; it also works if the TERM value isn't
                            # a hash (thanks, Hashie!)
                            if !hit.params.nil? && (value = hit.params.send(*[:dig, term.split('.')].flatten))
                              # TODO: Join arrays for facts too?
                              value = value.sort.join(',') if value.class == Hashie::Array
                              add << " #{term}=#{value}"
                              shown << term
                            elsif !hit.facts.nil? && (value = hit.facts.send(*[:dig, term.split('.')].flatten))
                              add << " #{term}=#{value}"
                              shown << term
                            end
                          end
                          # To match original noodle if a term-to-show is not shown, add TERM= to the output:
                          (show - shown).map { |i| add << " #{i}=" }
                          body << add + "\n"
                        end
                        body = body.sort.join
                      # 6. Otherwise, it's YAML
                      else
                        found = search.go(name_and_params_only: true)
                        body = found.results.map(&:to_puppet).join("\n") + "\n"
                      end
                      [body, status]
                    end
        end
      end
    end
  end
end
