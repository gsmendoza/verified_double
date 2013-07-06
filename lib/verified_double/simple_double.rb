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

    def method_doubles
      internal.send('__mock_proxy').send('method_double').map {|method, method_double|
        MethodDouble.new(double: self, method: method, internal: method_double) }
    end

    def method_operator
      class_double? ? '.' : '#'
    end

    def method_signatures
      method_doubles.map(&:method_signatures).flatten
    end
  end
end
