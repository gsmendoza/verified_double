require 'rspec/fire'

require 'verified_double/boolean'
require 'verified_double/get_registered_signatures'
require 'verified_double/get_unverified_signatures'
require 'verified_double/get_verified_signatures'
require 'verified_double/method_signature'
require 'verified_double/method_signature_value'
require 'verified_double/output_unverified_signatures'
require 'verified_double/parse_method_signature'
require 'verified_double/recording_double'
require 'verified_double/report_unverified_signatures'

module VerifiedDouble
  def self.of_class(class_name, method_stubs = {})
    class_double = RSpec::Fire::FireClassDoubleBuilder.build(class_name).as_replaced_constant
    RecordingDouble.new(class_double, method_stubs).tap do |double|
      registry << double
    end
  end

  def self.of_instance(class_name, method_stubs = {})
    instance_double = RSpec::Fire::FireObjectDouble.new(class_name)
    RecordingDouble.new(instance_double, method_stubs).tap do |double|
      registry << double
    end
  end

  def self.registry
    @registry ||= []
  end
end

