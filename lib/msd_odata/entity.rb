module MsdOdata
  class Entity
    attr_reader :name, :attrs

    def initialize(name, attrs)
      @name = name
      @attrs = attrs
    end
  end
end
