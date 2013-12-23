module VerifiedDouble
  module RSpecMocksSyntaxOverrides
    def allow(*args)
      if args[0].respond_to?(:can_record_interactions?)
        VerifiedDouble.registry.current_double = args[0]
      else
        VerifiedDouble.registry.current_double = nil
      end
      super(*args)
    end

    def expect(*args)
      if args[0].respond_to?(:can_record_interactions?)
        if args[0].is_a?(RSpec::Mocks::AnyInstance::Recorder)
          raise "VerifiedDouble.any_instance_of doesn't support yet Rspec's " \
            "expect/allow syntax. Please use should_receive."
        else
          VerifiedDouble.registry.current_double = args[0]
        end


      else
        VerifiedDouble.registry.current_double = nil
      end
      super(*args)
    end

    def receive(*args)
      if VerifiedDouble.registry.current_double
        VerifiedDouble.registry.add_method_signature_with_current_double(args[0])
        super(*args).tap {|result| result.extend(VerifiedDouble::CanRecordInteractions) }
      else
        super(*args)
      end
    end
  end
end
