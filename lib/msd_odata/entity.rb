module MsdOdata
  class Entity
    attr_reader :name, :attrs

    def initialize(name, attrs = nil)
      @name = name
      @attrs = attrs
    end
  end
end
