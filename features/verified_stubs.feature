Feature: Verified stubs
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

    And the test suite has an after(:suite) callback asking VerifiedDouble to report unverified doubles:
      """
      require 'verified_double'
      require 'main'

      RSpec.configure do |config|
        config.after :suite do
          VerifiedDouble::ReportUnverifiedSignatures.new(VerifiedDouble.registry, self).execute
        end
      end
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
          instance_double.stub(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    And the test suite has a contract test for the stub:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

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

    And the test suite has a contract test for the stub:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified
