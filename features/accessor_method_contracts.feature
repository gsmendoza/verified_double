Feature: 40. Accessor method contracts
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

    And the test suite is configured to use VerifiedDouble:
      """
      require 'verified_double'
      require 'verified_double/rspec_configuration'
      require 'main'
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

  Scenario: Verifying mocks for readers
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator)
          collaborator.value
        end
      end

      class Collaborator
        attr_reader :value

        def initialize(value)
          @value = value
        end
      end

      class SomeValue
      end
      """

    And a test that uses VerifiedDouble to stub an object:
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
        subject { described_class.new(SomeValue.new) }
        it { should verify_reader_contract('Collaborator#value=>SomeValue') }
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified
