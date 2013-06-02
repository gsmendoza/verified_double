module VerifiedDouble
  class VerifyDoublesService
    def initialize(world)
      @world = world
    end

    def execute
      unverified_method_signatures = @world.unverified_method_signatures
      if unverified_method_signatures.any?
        output = ["The following mocks are not verified:" ] + unverified_method_signatures
        puts output.join("\n")
      end
    end
  end
end
