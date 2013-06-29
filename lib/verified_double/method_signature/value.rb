module VerifiedDouble
  class MethodSignature
    class Value
      attr_reader :content

      def initialize(content)
        @content = content
      end

      def belongs_to?(other)
        if self.content.is_a?(Class) || ! other.content.is_a?(Class)
          self.content == other.content
        else
          self.content_class.ancestors.include?(other.content)
        end
      end

      def content_as_instance
        if self.content.is_a?(Class)
          begin
            content.new
          rescue NoMethodError
            Object.new
          end
        else
          self.content
        end
      end

      def content_class
        if content.is_a?(RSpec::Mocks::Mock)
          content.instance_variable_get('@name').constantize
        elsif content == true or content == false
          VerifiedDouble::Boolean
        else
          content.class
        end
      end

      def recommended_value
        self.class.new(self.content_class)
      end
    end
  end
end
