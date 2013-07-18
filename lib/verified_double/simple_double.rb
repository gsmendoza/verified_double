module VerifiedDouble
  class SimpleDouble
    attr_reader :internal

    def initialize(internal)
      @internal = internal
    end

    def class_name
      class_double? ? internal.name : internal.instance_variable_get('@name')
    end

    def class_double?
      internal.is_a?(Class)
    end

    def method_operator
      class_double? ? '.' : '#'
    end
  end
end
