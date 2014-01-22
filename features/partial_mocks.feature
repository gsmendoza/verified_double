Feature: 65. Partial mocks

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(input)
          some_method(input)
        end

        def some_method(input)
          SomeOutput.new
        end

        def self.do_something(input)
          some_method(input)
        end

        def self.some_method(input)
          SomeOutput.new
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

  Scenario: Verified partial mocks of instance variables

    Given a test that uses VerifiedDouble to mock the object under test:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          object_under_test = ObjectUnderTest.new
          expect(VerifiedDouble.wrap(object_under_test))
            .to receive(:some_method).with(input).and_return(output)

          object_under_test.do_something(input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe ObjectUnderTest do
        describe '#some_method(SomeInput)=>SomeOutput', verifies_contract: true do
          it "tests something" do
            # do nothing
          end
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Unverified partial mocks of instance variables

    Given a test that uses VerifiedDouble to mock the object under test:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          object_under_test = ObjectUnderTest.new
          expect(VerifiedDouble.wrap(object_under_test))
            .to receive(:some_method).with(input).and_return(output)

          object_under_test.do_something(input)
        end
      end
      """

    And the test suite does not have a contract test for the mock

    When I run the test suite
    Then I should be informed that the stub is unverified:
      """
      The following mocks are not verified:

      1. ObjectUnderTest#some_method(SomeInput)=>SomeOutput
      """

  Scenario: Verified partial mocks of class variables

    Given a test that uses VerifiedDouble to mock the object under test:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          expect(VerifiedDouble.wrap(ObjectUnderTest))
            .to receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.do_something(input)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe ObjectUnderTest do
        describe '.some_method(SomeInput)=>SomeOutput', verifies_contract: true do
          it "tests something" do
            # do nothing
          end
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: Unverified partial mocks of class variables

    Given a test that uses VerifiedDouble to mock the object under test:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something" do
          expect(VerifiedDouble.wrap(ObjectUnderTest))
            .to receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.do_something(input)
        end
      end
      """

    And the test suite does not have a contract test for the mock

    When I run the test suite
    Then I should be informed that the stub is unverified:
      """
      The following mocks are not verified:

      1. ObjectUnderTest.some_method(SomeInput)=>SomeOutput
      """

  Scenario: Class partial mocks should not affect the class in other tests
    Given the following classes:
      """
      class ObjectUnderTest
        def self.do_something(input)
          some_method(input)
          another_method(input)
        end

        def self.another_method(input)
          SomeOutput.new
        end

        def self.some_method(input)
          SomeOutput.new
        end
      end

      class SomeInput
      end

      class SomeOutput
      end
      """

    And a test that uses both rspec-mock and VerifiedDouble to partially mock a class:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }

        it "tests something with VerifiedDouble partial mock" do
          expect(VerifiedDouble.wrap(ObjectUnderTest))
            .to receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.do_something(input)
        end

        it "tests something with rspec-mock" do
          expect(ObjectUnderTest)
            .to receive(:another_method).with(input).and_return(output)

          ObjectUnderTest.do_something(input)
        end
      end
      """

    When I run the test suite
    Then I should be informed that only the VerifiedDouble.wrap mock is unverified:
      """
      The following mocks are not verified:

      1. ObjectUnderTest.some_method(SomeInput)=>SomeOutput
      """
