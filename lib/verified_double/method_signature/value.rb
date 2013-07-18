module VerifiedDouble
  class MethodSignature
    class Value
      attr_reader :content

      def self.from(content)
        if content == true || content == false
          BooleanValue.new(content)
        elsif content.is_a?(RSpec::Mocks::Mock)
          RspecDoubleValue.new(content)
        elsif content.is_a?(Module)
          ClassValue.new(content)
        else
          InstanceValue.new(content)
        end
      end

      def initialize(content)
        @content = content
      end

      def content_class
        content.class
      end

      def recommended_value
        MethodSignature::Value.from(self.content_class)
      end
    end
  end
end
