module VerifiedDouble
  class GetUnverifiedSignatures
    def initialize(get_registered_signatures, get_verified_signatures)
      @get_registered_signatures, @get_verified_signatures = get_registered_signatures, get_verified_signatures
    end

    def execute
      @get_registered_signatures.execute - @get_verified_signatures.execute
    end
  end
end
