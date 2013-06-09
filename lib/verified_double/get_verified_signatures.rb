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
        .map{|method_signature_string| ParseMethodSignature.new(method_signature_string).execute }
    end
  end
end
