module VerifiedDouble
  class GetRegisteredSignatures
    def initialize(double_registry)
      @double_registry = double_registry
    end

    def execute
      @double_registry.map(&:method_signatures).flatten.map(&:to_s).uniq
    end
  end
end
