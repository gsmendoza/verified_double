module VerifiedDouble
  class MethodSignature
    class BooleanValue < Value
      def content_class
        VerifiedDouble::Boolean
      end
    end
  end
end
