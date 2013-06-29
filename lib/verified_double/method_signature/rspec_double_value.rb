module VerifiedDouble
  class MethodSignature
    class RspecDoubleValue <  InstanceDoubleValue
      def content_class
        content.instance_variable_get('@name').constantize
      end
    end
  end
end
