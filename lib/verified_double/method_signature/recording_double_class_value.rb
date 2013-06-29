module VerifiedDouble
  class MethodSignature
    class RecordingDoubleClassValue < Value
      def belongs_to?(other)
        Value.from(content.doubled_class).belongs_to?(other)
      end
    end
  end
end
