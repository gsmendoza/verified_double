module VerifiedDouble
  class StackFrame
    def initialize(string)
      @string = string
    end

    def to_s
      @string.gsub(%r{.*/spec/}, "./spec/")
    end
  end
end
