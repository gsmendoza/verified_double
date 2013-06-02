module VerifiedDouble
  class MethodSignature
    attr_accessor :args, :method, :recording_double, :return_value

    def initialize(recording_double)
      @recording_double = recording_double
    end

    def to_s
      result = [
        "#{recording_double.class_name}#{recording_double.method_operator}#{method}(#{args && args.map(&:class).join(', ')})",
        return_value && return_value.class]
      result.compact.join("=>")
    end
  end
end
