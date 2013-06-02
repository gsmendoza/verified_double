module VerifiedDouble
  class GetVerifiedSignatures
    def initialize(nested_example_group)
      @nested_example_group = nested_example_group
    end

    def execute
      results = @nested_example_group
        .class
        .descendant_filtered_examples
        .map{|example| example.metadata[:verifies_contract] }
        .compact
        .uniq
    end
  end
end
