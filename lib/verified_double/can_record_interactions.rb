module VerifiedDouble
  module CanRecordInteractions
    def and_return(*return_values)
      VerifiedDouble.registry.last.return_values = [MethodSignature::Value.from(return_values[0])]
      super(*return_values)
    end

    def should_receive(*args)
      VerifiedDouble.registry.add_method_signature(self, args[0])
      super(*args).tap do |result|
        VerifiedDouble.doubles_in_current_test << result
        result.extend(VerifiedDouble::CanRecordInteractions)
      end
    end

    def stub(*args)
      VerifiedDouble.registry.add_method_signature(self, args[0])
      super(*args).tap do |result|
        VerifiedDouble.doubles_in_current_test << result
        result.extend(VerifiedDouble::CanRecordInteractions)
      end
    end

    def with(*args)
      VerifiedDouble.registry.last.args =
        args.map{|arg| MethodSignature::Value.from(arg) }
      super(*args)
    end
  end
end
