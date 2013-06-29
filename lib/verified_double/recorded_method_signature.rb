module VerifiedDouble
  class RecordedMethodSignature < MethodSignature
    attr_accessor :stack_frame

    def to_s
      "#{super}\n  # #{stack_frame}"
    end
  end
end
