module VerifiedDouble
  class MethodSignature
    class Value
      attr_reader :content

      def self.from(content)
        if content == true || content == false
          BooleanValue.new(content)
        elsif content.is_a?(RSpec::Mocks::Mock)
          RspecDoubleValue.new(content)
        elsif content.is_a?(Class)
          ClassValue.new(content)
        else
          new(content)
        end
      end

      def initialize(content)
        @content = content
      end

      def belongs_to?(other)
        if ! other.content.is_a?(Class)
          self.content == other.content
        else
          self.content_class.ancestors.include?(other.content)
        end
      end

      def content_as_instance
        self.content
      end

      def content_class
        content.class
      end

      def recommended_value
        self.class.new(self.content_class)
      end
    end
  end
end
