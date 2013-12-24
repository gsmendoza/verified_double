Feature: 10. Verified mocks
  As a developer
  I want to be informed if the mocks I use are verified by contract tests

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

  Scenario: Verified instance doubles
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          expect(instance_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Instantiating an instance double with a class argument
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance(Collaborator) }

        it "tests something" do
          expect(instance_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Unverified instance doubles
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          expect(instance_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
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

  Scenario: Verified class doubles
    Given a test that uses VerifiedDouble to mock a class:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:class_double) { VerifiedDouble.of_class('Collaborator') }

        it "tests something" do
          expect(class_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.do_something(input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator.some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Instantiating a class double with a class argument
    Given a test that uses VerifiedDouble to mock a class:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:class_double) { VerifiedDouble.of_class(Collaborator) }

        it "tests something" do
          expect(class_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.do_something(input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator.some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Unverified class doubles
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:class_double) { VerifiedDouble.of_class('Collaborator') }

        it "tests something" do
          expect(class_double).to receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(class_double, input)
        end
      end
      """

    And the test suite does not have a contract test for the mock
    When I run the test suite
    Then I should be informed that the mock is unverified:
      """
      The following mocks are not verified:

      1. Collaborator.some_method(SomeInput)=>SomeOutput
      """

