module VerifiedDouble
  class MethodSignature
    attr_accessor :args, :class_name, :method, :method_operator, :return_values

    def initialize(attributes = {})
      attributes.each do |name, value|
        self.send "#{name}=", value
      end
    end

    def accepts?(other)
      self.class_name == other.class_name &&
      self.method_operator == other.method_operator &&
      self.method == other.method &&
      self.args.size == other.args.size &&
      (0 ... args.size).all?{|i| self.args[i].accepts?(other.args[i]) } &&
      self.return_values.size == other.return_values.size &&
      (0 ... return_values.size).all?{|i| self.return_values[i].accepts?(other.return_values[i]) }
    end

    def args
      @args ||= []
    end

    def eql?(other)
      to_s.eql?(other.to_s)
    end

    def hash
      to_s.hash
    end

    def recommended_verified_signature
      self.clone.tap do |result|
        result.args = result.args.map{|arg| arg.recommended_value }
        result.return_values = result.return_values.map{|return_value| return_value.recommended_value }
      end
    end

    def return_values
      @return_values ||= []
    end

    def to_s
      args_string = args.map(&:value).map{|v| v || 'nil'}.join(', ')
      return_values_string = return_values.map(&:value).map{|v| v || 'nil'}.join(', ')
      return_values_string = nil if return_values_string.empty?

      result = [
        "#{class_name}#{method_operator}#{method}(#{args_string})",
        return_values_string]
      result.flatten.compact.join("=>")
    end
  end
end
