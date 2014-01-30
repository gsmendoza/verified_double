module VerifiedDouble
  module RSpecMocksSyntaxOverrides
    def allow(*args)
      VerifiedDouble.registry.update_current_double args[0]
      super(*args)
    end

    def allow_any_instance_of(*args)
      VerifiedDouble.registry.update_current_double nil
      super(*args)
    end

    def expect(*args)
      VerifiedDouble.registry.update_current_double args[0]
      super(*args)
    end

    def expect_any_instance_of(*args)
      VerifiedDouble.registry.update_current_double nil
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
