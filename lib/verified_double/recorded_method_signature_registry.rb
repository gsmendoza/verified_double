module VerifiedDouble
  class RecordedMethodSignatureRegistry < Array
    attr_accessor :current_double

    def add_method_signature(a_double, method)
      simple_double = SimpleDouble.new(a_double)
      self << simple_double.build_recorded_method_signature(method)
    end

    def add_method_signature_with_current_double(method)
      add_method_signature(current_double, method)
    end
  end
end