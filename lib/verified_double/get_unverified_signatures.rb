module VerifiedDouble
  class GetUnverifiedSignatures
    def initialize(get_registered_signatures, get_verified_signatures)
      @get_registered_signatures, @get_verified_signatures = get_registered_signatures, get_verified_signatures
    end

    def execute
      @get_registered_signatures.execute.select{|registered_signature|
       @get_verified_signatures.execute.all?{|verified_signature|
        ! registered_signature.accepts?(verified_signature) } }
    end
  end
end
