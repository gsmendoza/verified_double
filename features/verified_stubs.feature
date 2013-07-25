Feature: 02. Verified stubs
  As a developer
  I want to be informed if the stubs I use are verified by contract tests

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator, input)
          collaborator.some_method(input)
        end
      end

      class Collaborator
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

  Scenario: Stubbed doubles
    Given a test that uses VerifiedDouble to stub an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          allow(instance_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should be informed that the mock is unverified:
      """
      The following mocks are not verified:

      1. Collaborator#some_method(SomeInput)=>SomeOutput
      """

  Scenario: Stubbed doubles using hash syntax
    Given a test that uses VerifiedDouble to stub an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator', some_method: output) }

        it "tests something" do
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should be informed that the mock is unverified:
      """
      The following mocks are not verified:

      1. Collaborator#some_method()=>SomeOutput
      """
