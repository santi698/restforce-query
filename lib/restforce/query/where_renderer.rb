module Restforce
  class Query
    # Private class, used by Restforce::Query
    class WhereRenderer
      MAX_WHERE_SIZE = 12_000
      WhereTooLargeError = StandardError.new("Maximum WHERE size of #{MAX_WHERE_SIZE} exceeded")
      def initialize(custom_conditions, conditions)
        @custom_conditions = custom_conditions || []
        @conditions = conditions || []
      end

      def self.render(custom_conditions, conditions)
        new(custom_conditions, conditions).render
      end

      def render
        conditions_text = render_custom + render_connector + render_conditions
        return '' if conditions_text.strip.size.zero?
        result = " WHERE #{conditions_text}"
        raise WhereTooLargeError if result.size > MAX_WHERE_SIZE
        result
      end

      private

      def render_conditions
        return '' if @conditions.count.zero?
        @conditions.map do |k, v|
          next "#{k} IN #{render_list(v)}" if v.is_a? Enumerable
          next "#{k} = NULL" if v.nil?
          "#{k} = #{render_item(v)}"
        end.join(' AND ')
      end

      def render_connector
        (@conditions.count > 0) && (@custom_conditions.count > 0)? ' AND ' : ''
      end

      def render_custom
        return '' if @custom_conditions.count.zero?
        @custom_conditions.join(' AND ')
      end

      def render_list(*items)
        "(#{items.flatten.map { |i| render_item(i) }.join(',')})"
      end

      def render_item(item)
        return "'#{item}'" if item.is_a? String
        item
      end
    end
  end
end
