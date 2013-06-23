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
        ! registered_signature.accepts?(verified_signature) } }
      self
    end

    def merge_verified_signatures
      @verified_signatures = @verified_signatures_from_tags + @verified_signatures_from_matchers
      self
    end

    def output_unverified_signatures
      if @unverified_signatures.any?
        output = ["The following mocks are not verified:" ] + @unverified_signatures.map(&:recommended_verified_signature).map(&:to_s).sort
        puts output.join("\n")
      end
      self
    end

    def set_registered_signatures
      @registered_signatures = VerifiedDouble.registry.map(&:method_signatures).flatten.uniq
      self
    end

    def set_verified_signatures_from_matchers
      @verified_signatures_from_matchers = VerifiedDouble.verified_signatures_from_matchers
      self
    end

    def set_verified_signatures_from_tags(nested_example_group)
      @verified_signatures_from_tags = nested_example_group
        .class
        .descendant_filtered_examples
        .map{|example| example.metadata[:verifies_contract] }
        .compact
        .uniq
        .map{|method_signature_string| ParseMethodSignature.new(method_signature_string).execute }
      self
    end
  end
end
