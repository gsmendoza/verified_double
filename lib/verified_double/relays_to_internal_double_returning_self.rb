module VerifiedDouble
  module RelaysToInternalDoubleReturningSelf
    def relays_to_internal_double_returning_self(*methods)
      methods.each do |method|
        define_method method do |*args|
          @double_call.send(method, *args)
          self
        end
      end
    end
  end
end