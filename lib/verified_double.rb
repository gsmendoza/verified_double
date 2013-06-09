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
  def self.of_class(class_name)
    RecordingDouble.new(RSpec::Fire::FireClassDoubleBuilder.build(class_name).as_replaced_constant).tap do |double|
      registry << double
    end
  end

  def self.of_instance(class_name)
    RecordingDouble.new(RSpec::Fire::FireObjectDouble.new(class_name)).tap do |double|
      registry << double
    end
  end

  def self.registry
    @registry ||= []
  end
end

