module VerifiedDouble
  class MethodSignature
    class InstanceDoubleValue < Value
      def content_as_instance
        Value.from(content_class).content_as_instance
      end
    end
  end
end
