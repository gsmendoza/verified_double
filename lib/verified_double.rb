require 'active_support/core_ext/string'
require 'rspec/mocks'

require 'verified_double/boolean'
require 'verified_double/can_record_interactions'
require 'verified_double/matchers'
require 'verified_double/method_signature'
require 'verified_double/method_signature/value'
require 'verified_double/method_signature/instance_value'
require 'verified_double/method_signature/boolean_value'
require 'verified_double/method_signature/class_value'
require 'verified_double/method_signature/rspec_double_value'
require 'verified_double/method_signatures_report'
require 'verified_double/parse_method_signature'
require 'verified_double/rspec_mocks_syntax_overrides'
require 'verified_double/recorded_method_signature'
require 'verified_double/recorded_method_signature_registry'
require 'verified_double/simple_double'
require 'verified_double/stack_frame'

module VerifiedDouble
  extend RSpec::Mocks::ExampleMethods

  def self.of_class(class_name, options = {})
    options[:transfer_nested_constants] = true if options[:transfer_nested_constants].nil?
    VerifiedDouble.record(stub_const(class_name, Class.new, options))
  end

  def self.of_instance(*args)
    d = double(*args)
    simple_double = SimpleDouble.new(d)

    if args[1]
      args[1].each do |method, return_value|
        method_signature = RecordedMethodSignature.new(
          class_name: simple_double.class_name,
          method_operator: simple_double.method_operator,
          method: method.to_s,
          stack_frame: StackFrame.new(caller(0).detect{|line| line =~ /_spec\.rb/ }),
          return_values: [MethodSignature::Value.from(return_value)])

        # Ensures that the stub doesn't become the last method signature.
        VerifiedDouble.registry.insert 0, method_signature
      end
    end
    VerifiedDouble.record(d)
  end

  def self.record(a_double)
    a_double.extend(VerifiedDouble::CanRecordInteractions)
    a_double
  end

  def self.registry
    @registry ||= RecordedMethodSignatureRegistry.new
  end

  def self.report_unverified_signatures(nested_example_group)
    MethodSignaturesReport.new
      .set_registered_signatures
      .set_verified_signatures_from_tags(nested_example_group)
      .set_verified_signatures_from_matchers
      .merge_verified_signatures
      .identify_unverified_signatures
      .output_unverified_signatures
  end

  def self.verified_signatures_from_matchers
    @verified_signatures_from_matchers ||= []
  end
end

