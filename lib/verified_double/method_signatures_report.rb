module VerifiedDouble
  class MethodSignaturesReport
    attr_accessor :registered_signatures,  :unverified_signatures, :verified_signatures,
      :verified_signatures_from_tags,:verified_signatures_from_matchers

    def initialize
      @registered_signatures = []
      @unverified_signatures = []
      @verified_signatures = []
      @verified_signatures_from_tags = []
      @verified_signatures_from_matchers = []
    end

    def identify_unverified_signatures
      @unverified_signatures = @registered_signatures.select{|registered_signature|
       @verified_signatures.all?{|verified_signature|
        ! registered_signature.belongs_to?(verified_signature) } }
      self
    end

    def merge_verified_signatures
      @verified_signatures = @verified_signatures_from_tags + @verified_signatures_from_matchers
      self
    end

    def output_unverified_signatures
      if @unverified_signatures.any?
        output = [nil, "The following mocks are not verified:" ] +
          @unverified_signatures
            .map(&:recommended_verified_signature)
            .map(&:to_s)
            .sort
            .each_with_index
            .map{|string, i| "#{i+1}. #{string}" } +
          ["For more info, check out https://www.relishapp.com/gsmendoza/verified-double."]
        puts output.join("\n\n")
      end
      self
    end

    def set_registered_signatures
      @registered_signatures = VerifiedDouble.registry.uniq
      self
    end

    def set_verified_signatures_from_matchers
      @verified_signatures_from_matchers = VerifiedDouble.verified_signatures_from_matchers
      self
    end

    def set_verified_signatures_from_tags(nested_example_group)
      examples = nested_example_group
        .class
        .descendant_filtered_examples

      verified_signatures = examples.map do |example|
        if example.metadata[:verifies_contract] == true
          ExampleMetadata.new(example.metadata).verified_signature
        else
          example.metadata[:verifies_contract]
        end
      end

      @verified_signatures_from_tags = verified_signatures
        .compact
        .uniq
        .map{|method_signature_string| ParseMethodSignature.new(method_signature_string).execute }

      self
    end
  end
end
