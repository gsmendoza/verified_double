require 'active_support/core_ext/string'
require 'pry'

require 'verified_double/boolean'

# Requiring because these are Value objects.
# As value objects, we treat them as primitives.
# Hence, there should be no need to mock or stub them.
require "verified_double/method_signature"
require "verified_double/method_signature/value"
require 'verified_double/method_signature/boolean_value'
require 'verified_double/method_signature/class_value'
require 'verified_double/method_signature/rspec_double_value'

# Requiring because these are macros.
require 'verified_double/relays_to_internal_double_returning_self'

RSpec.configure do |config|
end
