module VerifiedDouble
  class MethodSignature
    class InstanceDoubleValue < InstanceValue
      def content_as_instance
        Value.from(content_class).content_as_instance
      end
    end
  end
end
