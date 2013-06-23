require 'rspec/expectations'

module VerifiedDouble
  module Matchers
    extend RSpec::Matchers::DSL

    matcher :verify_accessor_contract do |expected|
      match do |actual|
        method_signature = ParseMethodSignature.new(expected).execute

        VerifiedDouble.verified_signatures_from_matchers << method_signature

        raise CannotHandleMultipleReturnValues if method_signature.return_values.size > 1

        value = method_signature.return_values.first.as_instance
        actual.send "#{method_signature.method}=", value
        actual.send(method_signature.method) == value
      end
    end

    matcher :verify_reader_contract do |expected|
      match do |actual|
        method_signature = ParseMethodSignature.new(expected).execute

        VerifiedDouble.verified_signatures_from_matchers << method_signature

        raise CannotHandleMultipleReturnValues if method_signature.return_values.size > 1

        actual.send(method_signature.method).is_a?(method_signature.return_values.first.value)
      end
    end

    class CannotHandleMultipleReturnValues < Exception; end
  end
end
