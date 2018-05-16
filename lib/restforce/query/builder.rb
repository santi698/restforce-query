require_relative 'where_renderer'

module Restforce
  class Query
    # Private class, used by Restforce::Query
    class Builder
      MAX_QUERY_SIZE = 20_000
      QueryTooLargeError = StandardError.new("Maximum query size of #{MAX_QUERY_SIZE} exceeded")
      def initialize
        @fields = []
        @tables = []
        @custom_conditions = []
        @conditions = {}
        @groupings = []
        @limit = nil
        @distinct = false
      end

      def select(*fields)
        @fields += (fields.flatten - @fields)
        self
      end

      def select_distinct(*fields)
        @fields += (fields.flatten - @fields)
        @groupings += (fields.flatten - @groupings)
        self
      end

      def distinct
        @distinct = true
        self
      end

      def from(*tables)
        @tables = tables.flatten
        self
      end

      def where(custom_condition = nil, **conditions)
        @custom_conditions << "(#{custom_condition})" unless custom_condition.nil?
        @conditions = @conditions.merge(conditions)
        self
      end

      def group_by(*groupings)
        @groupings += (groupings.flatten - @groupings)
        self
      end

      def limit(lim)
        @limit = lim
        self
      end

      def render
        raise 'There must be at least one field in the SELECT clause' if @fields.empty?
        raise 'There must be at least one table in the FROM clause' if @tables.empty?
        result = "#{render_select}#{render_from}#{render_where}#{render_group_by}#{render_limit}"
        raise QueryTooLargeError if result.size > MAX_QUERY_SIZE
        result.strip
      end

      alias to_s render

      private

      def render_select
        "SELECT #{@fields.join(', ')}"
      end

      def render_from
        " FROM #{@tables.join(', ')}"
      end

      def render_where
        WhereRenderer.render(@custom_conditions, @conditions)
      end

      def render_group_by
        # This line adds all fields in the select which were not explicitly grouped
        @groupings += (@fields - @groupings) if @distinct
        return '' if @groupings.empty?
        " GROUP BY #{@groupings.join(', ')}"
      end

      def render_limit
        return '' if @limit.nil?
        " LIMIT #{@limit}"
      end
    end
  end
end
