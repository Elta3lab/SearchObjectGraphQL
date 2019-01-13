# frozen_string_literal: true

module Resolvers
  class CategorySearch < Resolvers::BaseSearchResolver
    type types[Types::CategoryType]
    description 'Lists categories'

    OrderEnum = GraphQL::EnumType.define do
      name 'CategoryOrder'

      value 'RECENT'
      value 'NAME'
    end

    scope { Category.all }

    option :id, type: types.String, with: :apply_id_filter
    option :name, type: types.String, with: :apply_name_filter
    option :order, type: OrderEnum, default: 'RECENT'

    def apply_id_filter(scope, value)
      scope.where id: value
    end

    def apply_name_filter(scope, value)
      scope.where 'name LIKE ?', escape_search_term(value)
    end

    def apply_order_with_recent(scope)
      scope.order 'id DESC'
    end

    def apply_order_with_name(scope)
      scope.order 'name ASC'
    end
  end
end
