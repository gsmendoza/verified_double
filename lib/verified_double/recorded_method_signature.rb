module VerifiedDouble
  class RecordedMethodSignature < MethodSignature
    attr_reader :stack_frame

    def initialize(*args)
      @stack_frame = StackFrame.new(caller(0).detect{|line| line =~ /_spec\.rb/ })
      super(*args)
    end

    def to_s
      "#{super}\n  # #{stack_frame}"
    end
  end
end
