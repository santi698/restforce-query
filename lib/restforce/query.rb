require 'restforce'
require 'restforce/query/version'
require 'restforce/query/builder'
require 'restforce/query/where_renderer'

module Restforce
  # This is the main entry point for starting a query
  # Chain calls to: select, where, distinct, from, group_by, limit or select_distinct to use it
  class Query
    include Enumerable
    def initialize(query_builder = Builder.new, restforce_client = Restforce.new)
      @query_builder = query_builder
      @restforce_client = restforce_client
    end

    %i[select select_distinct distinct where from group_by limit].each do |method_name|
      # Defines instance methods and returns self to enable chaining
      define_method(method_name) do |*params|
        @query_builder.send(method_name, *params)
        # Flush cache results each time the query is modified
        @results = nil
        self
      end
      # Defines class methods for easy access. i.e.: SalesforceQuery.where(...)
      define_singleton_method(method_name) do |*params|
        new.send(method_name, *params)
      end
    end

    def execute
      return @results unless @results.nil?
      query = @query_builder.to_s
      @results = @restforce_client.query(query)
    end

    def each(&block)
      execute.each(&block)
    end

    def find
      @query_builder.limit(1)
      execute
      @results.first
    end
  end
end
