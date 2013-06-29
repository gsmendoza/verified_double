require 'delegate'
require 'verified_double/relays_to_internal_double_returning_self'

module VerifiedDouble
  class RecordingDouble < ::SimpleDelegator
    extend VerifiedDouble::RelaysToInternalDoubleReturningSelf

    relays_to_internal_double_returning_self :any_number_of_times, :and_raise,
      :and_throw, :at_least, :at_most, :exactly, :once, :twice

    attr_reader :class_name

    def initialize(double, class_name, method_stubs={})
      @double = double
      @class_name = class_name

      super(@double)
      method_stubs.each do |method, output|
        self.stub(method).and_return(output)
      end
    end

    def and_return(return_value)
      self.method_signatures.last.return_values = [MethodSignature::Value.from(return_value)]
      @double_call.and_return(return_value)
      self
    end

    def class
      class_double? ? Class : doubled_class
    end

    def class_double?
      ! double.is_a?(RSpec::Mocks::Mock)
    end

    def double
      __getobj__
    end

    def doubled_class
      class_name.constantize
    end

    def inspect
      to_s
    end

    def method_operator
      class_double? ? '.' : '#'
    end

    def method_signatures
      @method_signatures ||= []
    end

    def should_receive(method)
      add_method_signature method
      @double_call = double.should_receive(method)
      self
    end

    def stub(method)
      add_method_signature method
      @double_call = double.stub(method)
      self
    end

    def to_s
      "#{VerifiedDouble}.of_#{class_double? ? 'class' : 'instance' }('#{class_name}')"
    end

    def with(*args)
      self.method_signatures.last.args =
        args.map{|arg| MethodSignature::Value.from(arg) }
      @double_call.with(*args)
      self
    end

    private

    def add_method_signature(method)
      method_signature = MethodSignature.new(
        class_name: class_name,
        method_operator: method_operator,
        method: method.to_s)

      self.method_signatures << method_signature
    end
  end
end
