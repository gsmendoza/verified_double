module VerifiedDouble
  class SimpleDouble
    class MessageExpectation
      attr_accessor :method_double, :internal

      def initialize(attributes = {})
        attributes.each do |key, value|
          send "#{key}=", value
        end
      end

      def args
        expected_args = internal
          .instance_variable_get('@argument_list_matcher')
          .instance_variable_get('@expected_args')

        if expected_args.size == 1 && expected_args[0].is_a?(RSpec::Mocks::ArgumentMatchers::AnyArgsMatcher)
          []
        else
          expected_args.map{|arg| MethodSignature::Value.from(arg) }
        end
      end

      def method_signature
        MethodSignature.new(
          args: args,
          class_name: method_double.double.class_name,
          method: method_double.method,
          method_operator: method_double.double.method_operator,
          return_values: return_values)
      end

      def return_values
        internal
          .implementation
          .terminal_action
          .instance_variable_get('@values_to_return')
          .map{|return_value| MethodSignature::Value.from(return_value) }
      end
    end
  end
end
