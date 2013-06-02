module VerifiedDouble
  class ReportUnverifiedSignatures
    attr_accessor :double_registry, :nested_example_group

    def initialize(double_registry, nested_example_group)
      @double_registry, @nested_example_group = double_registry, nested_example_group
    end

    def execute
      VerifiedDouble::OutputUnverifiedSignatures.new(
        VerifiedDouble::GetUnverifiedSignatures.new(
          VerifiedDouble::GetRegisteredSignatures.new(double_registry),
          VerifiedDouble::GetVerifiedSignatures.new(nested_example_group))).execute
    end
  end
end
