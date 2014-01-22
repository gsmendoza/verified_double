module VerifiedDouble
  module RSpecMocksSyntaxOverrides
    def allow(*args)
      if VerifiedDouble.doubles_in_current_test.include?(args[0])
        VerifiedDouble.registry.current_double = args[0]
      else
        VerifiedDouble.registry.current_double = nil
      end
      super(*args)
    end

    def expect(*args)
      if VerifiedDouble.doubles_in_current_test.include?(args[0])
        VerifiedDouble.registry.current_double = args[0]
      else
        VerifiedDouble.registry.current_double = nil
      end
      super(*args)
    end

    def receive(*args)
      if VerifiedDouble.registry.current_double
        VerifiedDouble.registry.add_method_signature_with_current_double(args[0])
        super(*args).tap do |result|
          VerifiedDouble.doubles_in_current_test << result
          result.extend(VerifiedDouble::CanRecordInteractions)
        end
      else
        super(*args)
      end
    end
  end
end
