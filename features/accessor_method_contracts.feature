Feature: Accessor method contracts
  As a developer
  I want it to easy to verify contracts for accessor methods

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator)
          collaborator.value
        end
      end

      class Collaborator
        attr_accessor :value
      end

      class SomeValue
      end
      """

    And the test suite includes VerifiedDouble to verify doubles with accessor methods:
      """
      require 'verified_double'
      require 'main'

      RSpec.configure do |config|
        config.include VerifiedDouble::Matchers
        
        config.after :suite do
          VerifiedDouble.report_unverified_signatures(self)
        end
      end
      """

  Scenario: Verifying mocks for accessors
    Given a test that uses VerifiedDouble to stub an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:value) { SomeValue.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator', value: value) }

        it "tests something" do
          ObjectUnderTest.new.do_something(instance_double)
        end
      end
      """

    And the test suite has a contract test for the stub:
      """
      require 'spec_helper'

      describe Collaborator do
        it { should verify_accessor_contract('Collaborator#value=>SomeValue') }
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified
    