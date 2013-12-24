Feature: 60. Any instance

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator, input)
          collaborator.some_method(input)
        end

        def self.do_something(input)
          Collaborator.some_method(input)
        end
      end

      class Collaborator
        def self.some_method(input)
        end

        def some_method(input)
        end
      end

      class SomeInput
      end

      class SomeOutput
      end
      """

    And the test suite is configured to use VerifiedDouble:
      """
      require 'verified_double'
      require 'verified_double/rspec_configuration'
      require 'main'
      """

  Scenario: Verify any instance of a class

    Given a test that uses VerifiedDouble to mock any instance of the class:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          VerifiedDouble.any_instance_of(Collaborator)
            .should_receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.new.do_something(Collaborator.new, input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something",
          verifies_contract: 'Collaborator#some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Unverified any_instance mock
    Given a test that uses VerifiedDouble to mock any instance of the class:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          VerifiedDouble.any_instance_of(Collaborator)
            .should_receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.new.do_something(Collaborator.new, input)
        end
      end
      """

    And the test suite does not have a contract test for the mock
    When I run the test suite
    Then I should be informed that the mock is unverified:
      """
      The following mocks are not verified:

      1. Collaborator#some_method(SomeInput)=>SomeOutput
      """
