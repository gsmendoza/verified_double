module VerifiedDouble
  class MethodSignature
    class BooleanValue < InstanceValue
      def content_class
        VerifiedDouble::Boolean
      end
    end
  end
end
