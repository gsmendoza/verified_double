module VerifiedDouble
  class SimpleDouble
    class MethodDouble
      attr_accessor :double, :internal, :method

      def initialize(attributes = {})
        attributes.each do |key, value|
          send "#{key}=", value
        end
      end

      def message_expectations
        (internal[:expectations] + internal[:stubs]).map {|method_expectation|
          VerifiedDouble::SimpleDouble::MessageExpectation.new(method_double: self, internal: method_expectation) }
      end

      def method_signatures
        message_expectations.map(&:method_signature)
      end
    end
  end
end
