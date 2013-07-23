module VerifiedDouble
  module RSpecMocksSyntaxOverrides
    def expect(*args)
      VerifiedDouble.registry.current_double = args[0]
      super(*args)
    end

    def receive(*args)
      VerifiedDouble.registry.add_method_signature_with_current_double(args[0])
      super(*args).tap {|result| result.extend(VerifiedDouble::CanRecordInteractions) }
    end
  end
end
