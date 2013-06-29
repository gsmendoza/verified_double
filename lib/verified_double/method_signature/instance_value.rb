module VerifiedDouble
  class MethodSignature
    class InstanceValue < Value
      def belongs_to?(other)
        if other.is_a?(MethodSignature::InstanceValue)
          self.content == other.content
        else
          self.content_class.ancestors.include?(other.content)
        end
      end

      def content_as_instance
        self.content
      end
    end
  end
end
