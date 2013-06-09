module VerifiedDouble
  class MethodSignatureValue
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def accepts?(other)
      if self.value.is_a?(Class) || ! other.value.is_a?(Class)
        self.value == other.value
      else
        self.modified_class.ancestors.include?(other.value)
      end
    end

    def modified_class
      if value == true or value == false
        VerifiedDouble::Boolean
      else
        value.class
      end
    end

    def recommended_value
      self.class.new(self.modified_class)
    end
  end
end
