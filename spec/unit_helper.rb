require 'active_support/core_ext/string'
require 'pry'
require 'rspec/fire'

require 'verified_double/boolean'

# Requiring because these are Value objects.
# As value objects, we treat them as primitives.
# Hence, there should be no need to mock or stub them.
require "verified_double/method_signature"
require "verified_double/method_signature_value"

RSpec.configure do |config|
  config.include(RSpec::Fire)
end
