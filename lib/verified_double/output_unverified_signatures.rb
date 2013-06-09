module VerifiedDouble
  class OutputUnverifiedSignatures
    def initialize(get_unverified_signatures)
      @get_unverified_signatures = get_unverified_signatures
    end

    def execute
      if unverified_signatures.any?
        output = ["The following mocks are not verified:" ] + unverified_signatures.map(&:recommended_verified_signature)
        puts output.join("\n")
      end
    end

    def unverified_signatures
      @unverified_signatures ||= @get_unverified_signatures.execute
    end
  end
end
