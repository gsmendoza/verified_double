module VerifiedDouble
  module CanRecordInteractions
    def and_return(*return_values)
      VerifiedDouble.registry.last.return_values = [MethodSignature::Value.from(return_values[0])]
      super(*return_values)
    end

    def can_record_interactions?
      true
    end

    def should_receive(*args)
      VerifiedDouble.registry.add_method_signature(self, args[0])
      super(*args).tap {|result| result.extend(VerifiedDouble::CanRecordInteractions) }
    end

    def stub(*args)
      VerifiedDouble.registry.add_method_signature(self, args[0])
      super(*args).tap {|result| result.extend(VerifiedDouble::CanRecordInteractions) }
    end

    def with(*args)
      VerifiedDouble.registry.last.args =
        args.map{|arg| MethodSignature::Value.from(arg) }
      super(*args)
    end
  end
end
