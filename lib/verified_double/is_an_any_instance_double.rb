require 'verified_double/is_an_instance_double'

module VerifiedDouble
  module IsAnAnyInstanceDouble
    include IsAnInstanceDouble

    def verified_any_instance_double?
      true
    end
  end
end

