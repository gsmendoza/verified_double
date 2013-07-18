module VerifiedDouble
  class MethodSignature
    class RspecDoubleValue <  InstanceValue
      def content_as_instance
        Value.from(content_class).content_as_instance
      end

      def content_class
        content.instance_variable_get('@name').constantize
      end
    end
  end
end
