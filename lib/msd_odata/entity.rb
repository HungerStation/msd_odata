module MsdOdata
  class Entity
    ##
    # This class behaves as an entity model.
    # And takes the entity name in plural and capitalized format as 'name' attribute, and 'attrs' to pass payload or options.
    # Entity name should be the same as in the URI.
    # ex: {{base_url}}/Customers
    #     MsdOdata::Entity.new('Customers')
    #
    # This class also contains methods for 'OData system query options' to build a query.
    # To find out more about each method refer to: https://msdn.microsoft.com/en-us/library/gg309461.aspx
    attr_reader :name, :attrs, :query

    def initialize(name, attrs = {})
      @name = name
      @attrs = attrs
      @query = {}
    end

    # Specifies associations to expand in the result.
    # Usage example: account.expand('opportunity_customer_accounts')
    # @param properties [Array<Symbol>]
    # @return [self]
    def expand(*props)
      @query[:expand] = props.join(',')
      self
    end

    # Specifies properties to order the result by.
    # Usage example: entity.order_by(:Name, :id)
    # @param properties [Array<Symbol>]
    # @return [self]
    def order_by(*props)
      @query[:order_by] = props.join(',')
      self
    end

    # Specifies properties to select within the result.
    # @param properties [Array<Symbol>]
    # @return [self]
    def select(*props)
      @query[:select] = props.join(',')
      self
    end

    # Sets a number of records to skip before retrieving records in a collection.
    # @param properties [Array<Symbol>]
    # @return [self]
    def skip(*props)
      @query[:skip] = props.join(',')
      self
    end

    # Adds limit criteria to query.
    # @param value [to_i]
    # @return [self]
    def limit(value)
      @query[:top] = value.to_i
      self
    end

    # Adds a filter to the query.
    #
    # For example:
    #   AccountId eq 'HS-112233'
    #
    # Usage example: entity.where(entity[:AccountId].eq('ID-12345'))
    #
    # Operators:
    # eq, ne, gt, ge, lt, le, and, or, not
    #
    # @param expressions [Array<String>]
    # @return [self]
    def where(*exps)
      joined_exps = exps.join(' and ')

      if @query[:filters].nil?
        @query[:filters] = joined_exps
      else
        @query[:filters] += " and #{joined_exps}"
      end

      self
    end

    # Adds the logical operator 'or' to the query and start another chain.
    #
    # Usage example:
    #   entity.where(entity[:Type].eq('customer')).or(entity[:Id].eq('HS-XXXX'))
    #
    # @param expressions [Array<String>]
    # @return [self]
    def or(*exps)
      joined_exps = exps.join(' and ')
      @query[:filters] += " or #{joined_exps}"
      self
    end

    # Adds the logical operator 'and' to the query.
    # @param expressions [Array<String>]
    # @return [self]
    def and(*exps)
      joined_exps = exps.join(' and ')
      @query[:filters] += " and #{joined_exps}"
      self
    end

    # Adds the logical operator 'not' to the query.
    # This should be only used within 'and' or 'or' operators.
    #
    # Usage example:
    def not(*exps)
      joined_exps = exps.join(' and ')
      @query[:filters] += " not #{joined_exps}"
      self
    end

    # Sets an instance variable to be used in a chained expression.
    # Usage Example:
    #   self[:x].eq(1)
    #   This will generate the expression: x eq 1
    #
    # @param attr [to_s]
    # @return self
    def [](attr)
      @attr = attr.to_s
      self
    end

    # 'Equal to' expression
    # @param val [*]
    # @return [String]
    def eq(val)
      expression(:eq, val)
    end

    # 'Not Equal to' expression
    # @param val [*]
    # @return [String]
    def ne(val)
      expression(:ne, val)
    end

    # 'Greater Than' expression
    # @param val [*]
    # @return [String]
    def gt(val)
      expression(:gt, val)
    end

    # 'Greater Than or Equal' expression
    # @param val [*]
    # @return [String]
    def ge(val)
      expression(:ge, val)
    end

    # 'Less Than' expression
    # @param val [*]
    # @return [String]
    def lt(val)
      expression(:lt, val)
    end

    # 'Less Than or Equal' expression
    # @param val [*]
    # @return [String]
    def le(val)
      expression(:le, val)
    end

    private

    # Builds the expression as a string statement.
    # Note: Single qoutes on the value if it's a String or Symbol
    # Example: "Attribute eq 'value'"
    def expression(operator, val)
      val = (val.is_a?(String) || val.is_a?(Symbol)) ? "'#{val}'" : val
      "#{@attr} #{operator} #{val}"
    end
  end
end
