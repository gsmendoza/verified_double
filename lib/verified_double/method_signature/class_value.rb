module VerifiedDouble
  class MethodSignature
    class ClassValue < Value
      def belongs_to?(other)
        self.content == other.content
      end

      def content_as_instance
        begin
          content.new
        rescue NoMethodError
          Object.new
        end
      end
    end
  end
end
