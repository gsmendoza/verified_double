module VerifiedDouble
  class SimpleDouble
    attr_reader :internal

    def initialize(internal)
      @internal = internal
    end

    def build_recorded_method_signature(method)
      RecordedMethodSignature.new(
        class_name: class_name,
        method_operator: method_operator,
        method: method.to_s)
    end


    def class_name
      if class_double?
        internal.name
      elsif instance_double?
        internal.instance_variable_get('@name').to_s
      elsif any_instance_double?
        internal.instance_variable_get('@target').to_s
      else
        raise 'Unable to handle internal #{internal.inspect}'
      end
    end

    def any_instance_double?
      !! internal.instance_variable_get('@target')
    end

    def class_double?
      internal.respond_to?(:verified_class_double?)
    end

    def instance_double?
      !! internal.instance_variable_get('@name')
    end

    def method_operator
      class_double? ? '.' : '#'
    end
  end
end
