module VerifiedDouble
  class ParseMethodSignature
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def args
      results = string.scan(/\((.*)\)/)[0]
      if results
        results[0].split(',').map{|arg| MethodSignature::Value.new(eval(arg)) }
      else
        []
      end
    end

    def class_name
      string.scan(/(.*)[\.\#]/)[0][0]
    end

    def execute
      MethodSignature.new(
        class_name: class_name,
        method_operator: method_operator,
        method: method,
        args: args,
        return_values: return_values)
    end

    def method
      string.scan(/[\.\#](.*?)(=>|\(|$)/)[0][0]
    end

    def method_operator
      string.scan(/[\.\#]/)[0][0]
    end

    def return_values
      results = string.scan(/=>(.*)/)[0]
      if results
        results[0].split(',').map{|return_value|
          MethodSignature::Value.new(eval(return_value)) }
      else
        []
      end
    end
  end
end
